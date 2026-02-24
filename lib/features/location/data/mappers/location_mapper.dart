import 'package:sunny_or_not/features/location/data/dtos/location_dto.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';

extension LocationMapper on LocationDTO {
  Location toEntity() {
    return Location(
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
