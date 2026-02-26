import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/exceptions.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/weather/data/data_sources/i_weather_data_source.dart';
import 'package:sunny_or_not/features/weather/data/mappers/weather_mapper.dart';
import 'package:sunny_or_not/features/weather/data/mappers/weekly_weather_mapper.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/repositories/i_weather_repository.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherDataSource remoteDataSource;

  WeatherRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, CurrentWeather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final weatherDTO = await remoteDataSource.getCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(weatherDTO.toEntity());
    } on NetworkException {
      return const Left(ConnectionFailure());
    } on ServerException {
      return const Left(ServerFailure());
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<DailyWeather>>> getWeeklyWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final weathersDTO = await remoteDataSource.getWeeklyWeather(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(weathersDTO.toEntity());
    } on NetworkException {
      return const Left(ConnectionFailure());
    } on ServerException {
      return const Left(ServerFailure());
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
