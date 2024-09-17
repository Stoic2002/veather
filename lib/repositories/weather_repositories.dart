import '../models/weather_model.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService _weatherApiService;

  WeatherRepository(this._weatherApiService);

  Future<WeatherModel> getWeather(String query) async {
    return await _weatherApiService.getWeather(query);
  }

  Future<List<WeatherModel>> getWeeklyForecast(String query) async {
    return await _weatherApiService.getWeeklyForecast(query);
  }
}
