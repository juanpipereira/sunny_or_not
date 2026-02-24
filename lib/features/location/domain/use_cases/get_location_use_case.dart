import 'package:sunny_or_not/features/location/domain/entities/location.dart';
import 'package:sunny_or_not/features/location/domain/repositories/i_location_repository.dart';

class GetLocationUseCase {
  final ILocationRepository repository;
  GetLocationUseCase(this.repository);

  Future<Location> execute(String cityName) {
    return repository.getLocation(cityName);
  }
}
