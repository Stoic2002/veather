import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/constants.dart';

class WeatherApiService {
  Future<WeatherModel> getWeather(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$query'));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<List<WeatherModel>> getWeeklyForecast(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$query&days=7'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<WeatherModel> forecast =
            (jsonData['forecast']['forecastday'] as List)
                .map((data) => WeatherModel.fromJson(data['day']))
                .toList();
        return forecast;
      } else {
        throw Exception(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load weekly forecast: $e');
    }
  }
}
