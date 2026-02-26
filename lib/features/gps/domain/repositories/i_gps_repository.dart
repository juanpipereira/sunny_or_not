import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';

abstract class IGpsRepository {
  Future<Either<Failure, GpsCoordinates>> getCurrentCoordinates();
}
