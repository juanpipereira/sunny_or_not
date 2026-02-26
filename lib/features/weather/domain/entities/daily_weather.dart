import 'package:equatable/equatable.dart';
import 'package:sunny_or_not/features/weather/domain/entities/weather_condition.dart';

class DailyWeather extends Equatable {
  final double maxTemperature;
  final double minTemperature;
  final WeatherCondition weatherCondition;
  final DateTime date;

  const DailyWeather({
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCondition,
    required this.date,
  });

  @override
  List<Object?> get props => [
        maxTemperature,
        minTemperature,
        weatherCondition,
        date,
      ];
}
