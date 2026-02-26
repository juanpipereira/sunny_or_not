import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';

abstract class IWeatherRepository {
  Future<Either<Failure, CurrentWeather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, List<DailyWeather>>> getWeeklyWeather({
    required double latitude,
    required double longitude,
  });
}
