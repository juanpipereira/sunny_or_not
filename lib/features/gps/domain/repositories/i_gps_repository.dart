import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';

abstract class IGpsRepository {
  Future<GpsCoordinates> getCurrentCoordinates();
}
