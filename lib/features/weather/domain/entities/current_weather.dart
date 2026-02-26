import 'package:equatable/equatable.dart';
import 'package:sunny_or_not/features/weather/domain/entities/weather_condition.dart';

class CurrentWeather extends Equatable {
  final double temperature;
  final WeatherCondition weatherCondition;

  const CurrentWeather({
    required this.temperature,
    required this.weatherCondition,
  });

  @override
  List<Object?> get props => [temperature, weatherCondition];
}
