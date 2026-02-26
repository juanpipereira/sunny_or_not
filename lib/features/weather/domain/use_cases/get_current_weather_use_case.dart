import 'package:fpdart/fpdart.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/repositories/i_weather_repository.dart';

class GetCurrentWeatherUseCase {
  final IWeatherRepository repository;

  GetCurrentWeatherUseCase(this.repository);

  Future<Either<Failure, CurrentWeather>> execute({
    required double latitude,
    required double longitude,
  }) async {
    return await repository.getCurrentWeather(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
