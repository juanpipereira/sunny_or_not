import 'package:equatable/equatable.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoadInProgress extends LocationState {}

final class LocationLoadSuccess extends LocationState {
  final Location location;

  const LocationLoadSuccess(this.location);

  @override
  List<Object?> get props => [location];
}

final class LocationLoadFailure extends LocationState {
  final String message;

  const LocationLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
