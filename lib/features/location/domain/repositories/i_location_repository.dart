import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';

abstract class ILocationRepository {
  Future<Either<Failure, Location>> getLocation(String cityName);
}
