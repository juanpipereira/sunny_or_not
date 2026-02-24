import 'package:sunny_or_not/features/location/domain/entities/location.dart';

abstract class ILocationRepository {
  Future<Location> getLocation(String cityName);
}
