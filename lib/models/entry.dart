class Entry {
  int? id;
  String? title;
  String? body;
  late DateTime createdAt;
  PlaceInfo? placeInfo;
  WeatherInfo? weatherInfo;

  Entry([this.id, this.title, this.body, DateTime? createdAt, this.placeInfo, this.weatherInfo]) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Entry clone() {
    return Entry(
      id,
      title,
      body,
      createdAt,
      placeInfo,
      weatherInfo,
    );
  }
}

class WeatherInfo {
  int? celsius;
  int? weatherConditionCode;

  WeatherInfo([this.celsius, this.weatherConditionCode]);
}

class PlaceInfo {
  String? street;
  String? locality;
  String? country;

  PlaceInfo([this.street, this.locality, this.country]);
}