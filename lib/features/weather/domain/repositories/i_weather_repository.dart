import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';

abstract class IWeatherRepository {
  Future<CurrentWeather> getCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<List<DailyWeather>> getWeeklyWeather({
    required double latitude,
    required double longitude,
  });
}
