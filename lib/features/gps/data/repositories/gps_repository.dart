import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/exceptions.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/gps/data/data_sources/i_gps_device_data_source.dart';
import 'package:sunny_or_not/features/gps/data/mappers/gps_coordinates_mapper.dart';
import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';
import 'package:sunny_or_not/features/gps/domain/repositories/i_gps_repository.dart';

class GpsRepository implements IGpsRepository {
  final IGpsDeviceDataSource gpsDataSource;

  GpsRepository(this.gpsDataSource);

  @override
  Future<Either<Failure, GpsCoordinates>> getCurrentCoordinates() async {
    try {
      final gpsPosition = await gpsDataSource.getPosition();
      return Right(gpsPosition.toEntity());
    } on PermissionException {
      return const Left(GpsPermissionFailure());
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
