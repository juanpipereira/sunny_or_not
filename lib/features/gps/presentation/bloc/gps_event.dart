import 'package:equatable/equatable.dart';

sealed class GpsEvent extends Equatable {
  const GpsEvent();
  @override
  List<Object?> get props => [];
}

final class GpsCoordinatesRequested extends GpsEvent {}
