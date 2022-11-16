import 'package:geocoding/geocoding.dart';

class Entry {
  late DateTime createdAt;
  Placemark? placemark;
  EntryWeatherInfo? entryWeatherInfo;

  Entry([DateTime? createdAt, this.placemark, this.entryWeatherInfo]) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Entry clone() {
    return Entry(createdAt, placemark, entryWeatherInfo);
  }
}

class EntryWeatherInfo {
  int? celsius;
  int? weatherConditionCode;

  EntryWeatherInfo(this.celsius, this.weatherConditionCode);
}