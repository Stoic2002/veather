import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

class WeatherDisplay extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDisplay({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weather.location.name,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weather.current.tempC.round()}°',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            Text(
              'C',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
        Text(
          weather.current.condition.text,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 20),
        _buildWeatherInfoRow(),
        const SizedBox(height: 20),
        _buildForecastList(),
      ],
    );
  }

  Widget _buildWeatherInfoRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem('UV Index', weather.current.uv.toString()),
          _buildInfoItem('Humidity', '${weather.current.humidity}%'),
          _buildInfoItem('Precipitation', '${weather.current.precipMm}mm'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildForecastList() {
    // Note: The current model doesn't include forecast data, so this is a placeholder
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Conditions',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildForecastItem(
              weather.location.localtime,
              '${weather.current.tempC.round()}°',
              _getWeatherIcon(weather.current.condition.code)),
        ],
      ),
    );
  }

  Widget _buildForecastItem(String day, String temp, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(temp),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(int conditionCode) {
    // You would need to implement a mapping of condition codes to icons
    // This is a simplified example
    if (conditionCode < 1000) {
      return Icons.wb_sunny;
    } else if (conditionCode < 1030) {
      return Icons.cloud;
    } else {
      return Icons.wb_cloudy;
    }
  }
}
