import 'package:equatable/equatable.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoadInProgress extends WeatherState {}

final class WeatherLoadSuccess extends WeatherState {
  final CurrentWeather currentWeather;
  final List<DailyWeather> forecast;
  final double latitude;
  final double longitude;
  final String cityName;

  const WeatherLoadSuccess({
    required this.currentWeather,
    required this.forecast,
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  @override
  List<Object?> get props =>
      [currentWeather, forecast, latitude, longitude, cityName];
}

final class WeatherLoadFailure extends WeatherState {
  final String message;

  const WeatherLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
