import 'package:equatable/equatable.dart';

class DailyWeather extends Equatable {
  final double maxTemperature;
  final double minTemperature;
  final String condition;
  final DateTime date;

  const DailyWeather({
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    required this.date,
  });

  @override
  List<Object?> get props => [maxTemperature, minTemperature, condition, date];
}
