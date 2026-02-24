import 'package:equatable/equatable.dart';
import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';

sealed class GpsState extends Equatable {
  const GpsState();
  @override
  List<Object?> get props => [];
}

final class GpsInitial extends GpsState {}

final class GpsLoadInProgress extends GpsState {}

final class GpsLoadSuccess extends GpsState {
  final GpsCoordinates gpsCoordinates;
  const GpsLoadSuccess(this.gpsCoordinates);

  @override
  List<Object?> get props => [gpsCoordinates];
}

final class GpsLoadFailure extends GpsState {
  final String message;
  const GpsLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
