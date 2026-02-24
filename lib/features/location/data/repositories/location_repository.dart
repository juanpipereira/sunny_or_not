import 'package:sunny_or_not/features/location/data/data_sources/i_location_data_source.dart';
import 'package:sunny_or_not/features/location/data/mappers/location_mapper.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';
import 'package:sunny_or_not/features/location/domain/repositories/i_location_repository.dart';

class LocationRepository implements ILocationRepository {
  final ILocationDataSource remoteDataSource;
  LocationRepository(this.remoteDataSource);

  @override
  Future<Location> getLocation(String cityName) async {
    final locationDto = await remoteDataSource.searchCity(cityName);
    return locationDto.toEntity();
  }
}
