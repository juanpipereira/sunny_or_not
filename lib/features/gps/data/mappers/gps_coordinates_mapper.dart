import 'package:geolocator/geolocator.dart';
import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';

extension GpsCoordinatesMapper on Position {
  GpsCoordinates toEntity() {
    return GpsCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
