import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';
import 'package:sunny_or_not/features/location/domain/repositories/i_location_repository.dart';

class GetLocationUseCase {
  final ILocationRepository repository;
  GetLocationUseCase(this.repository);

  Future<Either<Failure, Location>> execute(String cityName) {
    return repository.getLocation(cityName);
  }
}
