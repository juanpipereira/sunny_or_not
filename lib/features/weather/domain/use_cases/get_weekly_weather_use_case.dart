import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/repositories/i_weather_repository.dart';

class GetWeeklyWeatherUseCase {
  final IWeatherRepository repository;

  GetWeeklyWeatherUseCase(this.repository);

  Future<List<DailyWeather>> execute({
    required double latitude,
    required double longitude,
  }) async {
    return await repository.getWeeklyWeather(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
