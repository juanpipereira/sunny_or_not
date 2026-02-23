import 'package:sunny_or_not/features/weather/data/dtos/weather_dto.dart';
import 'package:sunny_or_not/features/weather/data/dtos/weekly_weather_dto.dart';

abstract class IWeatherDataSource {
  Future<WeatherDTO> getCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<WeeklyWeatherDTO> getWeeklyWeather({
    required double latitude,
    required double longitude,
  });
}
