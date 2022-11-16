import 'package:geocoding/geocoding.dart';

class Entry {
  String? title;
  String? body;
  late DateTime createdAt;
  Placemark? placemark;
  EntryWeatherInfo? entryWeatherInfo;

  Entry([this.title, this.body, DateTime? createdAt, this.placemark, this.entryWeatherInfo]) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Entry clone() {
    return Entry(
      title,
      body,
      createdAt,
      placemark,
      entryWeatherInfo,
    );
  }
}

class EntryWeatherInfo {
  int? celsius;
  int? weatherConditionCode;

  EntryWeatherInfo(this.celsius, this.weatherConditionCode);
}