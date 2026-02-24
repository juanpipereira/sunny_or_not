import 'package:sunny_or_not/features/gps/data/data_sources/i_gps_device_data_source.dart';
import 'package:sunny_or_not/features/gps/data/mappers/gps_coordinates_mapper.dart';
import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';
import 'package:sunny_or_not/features/gps/domain/repositories/i_gps_repository.dart';

class GpsRepository implements IGpsRepository {
  final IGpsDeviceDataSource gpsDataSource;

  GpsRepository(this.gpsDataSource);

  @override
  Future<GpsCoordinates> getCurrentCoordinates() async {
    final position = await gpsDataSource.getPosition();
    return position.toEntity();
  }
}
