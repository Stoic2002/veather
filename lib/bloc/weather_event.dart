part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String query;

  const FetchWeather(this.query);

  @override
  List<Object> get props => [query];
}

class FetchWeeklyForecast extends WeatherEvent {
  final String query;

  const FetchWeeklyForecast(this.query);

  @override
  List<Object> get props => [query];
}
