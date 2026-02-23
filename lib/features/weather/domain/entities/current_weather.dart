import 'package:equatable/equatable.dart';

class CurrentWeather extends Equatable {
  final double temperature;
  final String condition;

  const CurrentWeather({
    required this.temperature,
    required this.condition,
  });

  @override
  List<Object?> get props => [temperature, condition];
}
