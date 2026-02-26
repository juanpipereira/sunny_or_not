import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/failures.dart';
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

    final currentResult = results[0] as Either<Failure, CurrentWeather>;
    final weeklyResult = results[1] as Either<Failure, List<DailyWeather>>;

    currentResult.fold(
      (failure) => emit(WeatherLoadFailure(failure.message)),
      (current) => weeklyResult.fold(
        (failure) => emit(WeatherLoadFailure(failure.message)),
        (weeklyWeather) => emit(
          WeatherLoadSuccess(
            currentWeather: current,
            forecast: weeklyWeather,
            latitude: event.latitude,
            longitude: event.longitude,
            cityName: event.cityName,
          ),
        ),
      ),
    );
  }
}
