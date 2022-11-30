import 'package:paper_rails/db/db_wrapper.dart';
import 'package:paper_rails/models/entry.dart';
import 'package:sqflite/sqlite_api.dart';
import 'collection.dart';

// Singleton
class EntryCollection extends Collection<Entry> {
  static EntryCollection? _collection;

  static Future<EntryCollection> get collection async => _collection ??= await _openCollection();

  final Database _db;

  // Table
  static const _entryTable = 'Entry';

  // Properties of entry
  static const _id = '_id';
  static const _title = 'title';
  static const _body = 'body';
  static const _createdAt = 'createdAt';

  // Properties of placemark
  static const _street = 'street';
  static const _locality = 'locality';
  static const _country = 'country';

  // Properties of weatherInfo
  static const _celsius = 'celsius';
  static const _weatherConditionCode = 'weatherConditionCode';

  EntryCollection._(this._db);
  
  @override
  Future<int> create(Entry object) async {
    final map = _entryToMap(object);
    return await _db.insert(_entryTable, map);
  }
  
  @override
  Future<int> delete(int object) async {
    return await _db.delete(_entryTable, where: '$_id = ?', whereArgs: [object]);
  }
  
  @override
  Future<Object?> get(int object) async {
    return await _db.query(_entryTable, where: '$_id = ?', whereArgs: [object]);
  }
  
  @override
  Future<List<Entry>> getAll() async {
    final entriesMap = await _db.query(
      _entryTable,
      orderBy: '$_createdAt DESC'
    );
    return entriesMap.map((map) => _fromMap(map)).toList();
  }
  
  @override
  Future<int> update(Entry object) async {
    return await _db.update(
      _entryTable,
      _entryToMap(object)
      // Allow update on all fields except id
      ..removeWhere((key, value) => key == _id),
      where: '$_id = ?',
      whereArgs: [object.id!]
    );
  }

  static Future<EntryCollection> _openCollection() async {
    var db = await DBWrapper.db;

    // Initialize entry table
    await db.execute(
      'CREATE TABLE IF NOT EXISTS $_entryTable ('
        '$_id INTEGER PRIMARY KEY,'
        '$_title TEXT,'
        '$_body TEXT,'
        '$_createdAt TEXT,'

        '$_street TEXT,'
        '$_locality TEXT,'
        '$_country TEXT,'

        '$_celsius INTEGER,'
        '$_weatherConditionCode INTEGER'
      ')'
    );

    return EntryCollection._(db);
  }

  Map<String, dynamic> _entryToMap(Entry entry) {
    return {
      _id: entry.id,
      _title: entry.title,
      _body: entry.body,
      _createdAt: entry.createdAt.toString(),
      _street: entry.placeInfo?.street,
      _locality: entry.placeInfo?.locality,
      _country: entry.placeInfo?.country,
      _celsius: entry.weatherInfo?.celsius,
      _weatherConditionCode: entry.weatherInfo?.weatherConditionCode
    };
  }

  Entry _fromMap(Map<String, dynamic> map) {
    final placeInfo = PlaceInfo(
      map[_street],
      map[_locality],
      map[_country]
    );

    final weatherInfo = WeatherInfo(
      map[_celsius],
      map[_weatherConditionCode]
    );

    return Entry(
      map[_id],
      map[_title],
      map[_body],
      DateTime.parse(map[_createdAt]),
      placeInfo,
      weatherInfo
    );
  }
}
