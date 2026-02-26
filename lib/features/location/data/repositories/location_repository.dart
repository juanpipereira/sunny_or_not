import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/exceptions.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/location/data/data_sources/i_location_data_source.dart';
import 'package:sunny_or_not/features/location/data/mappers/location_mapper.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';
import 'package:sunny_or_not/features/location/domain/repositories/i_location_repository.dart';

class LocationRepository implements ILocationRepository {
  final ILocationDataSource remoteDataSource;
  LocationRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, Location>> getLocation(String cityName) async {
    try {
      final dto = await remoteDataSource.searchCity(cityName);
      return Right(dto.toEntity());
    } on EmptyResultException {
      return const Left(LocationNotFoundFailure());
    } on NetworkException {
      return const Left(ConnectionFailure());
    } on ServerException {
      return const Left(ServerFailure());
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
