import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/use_cases/get_current_weather_use_case.dart';
import 'package:sunny_or_not/features/weather/domain/use_cases/get_weekly_weather_use_case.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_event.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase getCurrentWeather;
  final GetWeeklyWeatherUseCase getWeeklyWeather;

  WeatherBloc({
    required this.getCurrentWeather,
    required this.getWeeklyWeather,
  }) : super(WeatherInitial()) {
    on<WeatherFetchedByCoordinates>(_onWeatherFetchedByCoordinates);
  }

  Future<void> _onWeatherFetchedByCoordinates(
    WeatherFetchedByCoordinates event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadInProgress());

    try {
      final results = await Future.wait([
        getCurrentWeather.execute(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
        getWeeklyWeather.execute(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
      ]);

      emit(WeatherLoadSuccess(
        currentWeather: results[0] as CurrentWeather,
        forecast: results[1] as List<DailyWeather>,
        latitude: event.latitude,
        longitude: event.longitude,
        cityName: event.cityName,
      ));
    } catch (e) {
      emit(const WeatherLoadFailure(
          "We could not get weather data. Please try again"));
    }
  }
}
