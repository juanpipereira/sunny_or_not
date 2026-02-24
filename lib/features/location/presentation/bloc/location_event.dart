import 'package:equatable/equatable.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

final class LocationCitySearched extends LocationEvent {
  final String cityName;

  const LocationCitySearched(this.cityName);

  @override
  List<Object?> get props => [cityName];
}
