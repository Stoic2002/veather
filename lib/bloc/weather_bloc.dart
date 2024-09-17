import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_dicoding/models/weather_model.dart';
import 'package:test_dicoding/repositories/weather_repositories.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await _weatherRepository.getWeather(event.query);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });

    on<FetchWeeklyForecast>((event, emit) async {
      emit(WeatherLoading());
      try {
        final forecast =
            await _weatherRepository.getWeeklyForecast(event.query);
        emit(WeatherForecastLoaded(forecast));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
  }
}
