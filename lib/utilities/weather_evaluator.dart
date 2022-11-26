import 'package:flutter/cupertino.dart';
import 'package:weather/weather.dart';

mixin WeatherEvaluator {
  static const apiKey = '2349de183504122b3dd733cef5450d9b';
  WeatherFactory wf = WeatherFactory(apiKey);

  Future<Weather> determineWeather(double lat, double lon) async {
    return await wf.currentWeatherByLocation(lat, lon);
  }

  IconData? conditionCodeToWidget(int? code) {
    if (code == null) {
      return CupertinoIcons.clear;
    }
    if (200 <= code && code < 300) {
      return CupertinoIcons.cloud_bolt_fill;
    } else if (300 <= code && code < 500) {
      return CupertinoIcons.cloud_drizzle_fill;
    } else if (500 <= code && code < 600) {
      return CupertinoIcons.cloud_heavyrain_fill;
    } else if (600 <= code && code < 700) {
      return CupertinoIcons.snow;
    } else if (700 <= code && code < 800) {
      return CupertinoIcons.cloud_fog_fill;
    } else if (code == 800) {
      return CupertinoIcons.sun_max_fill;
    } else if (801 <= code && code < 900) {
      return CupertinoIcons.cloud_fill;
    } else {
      return CupertinoIcons.clear;
    }
  }
}