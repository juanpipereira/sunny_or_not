import 'package:equatable/equatable.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

final class WeatherFetchedByCoordinates extends WeatherEvent {
  final double latitude;
  final double longitude;
  final String cityName;

  const WeatherFetchedByCoordinates({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  @override
  List<Object?> get props => [latitude, longitude, cityName];
}
