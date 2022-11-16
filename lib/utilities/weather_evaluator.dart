import 'package:weather/weather.dart';

mixin WeatherEvaluator {
  static const apiKey = '2349de183504122b3dd733cef5450d9b';
  WeatherFactory wf = WeatherFactory(apiKey);

  Future<Weather> determineWeather(double lat, double lon) async {
    return await wf.currentWeatherByLocation(lat, lon);
  }
}