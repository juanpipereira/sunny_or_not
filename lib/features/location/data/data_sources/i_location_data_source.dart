import 'package:sunny_or_not/features/location/data/dtos/location_dto.dart';

abstract class ILocationDataSource {
  Future<LocationDTO> searchCity(String cityName);
}
