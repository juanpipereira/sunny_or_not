import 'package:sunny_or_not/features/weather/data/dtos/weather_dto.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';

extension WeatherDtoMapper on WeatherDTO {
  CurrentWeather toEntity() {
    return CurrentWeather(
      temperature: temperature,
      condition: _mapCodeToDescription(weatherCode),
    );
  }

  String _mapCodeToDescription(int code) {
    switch (code) {
      case 0:
        return 'Sunny';
      case >= 1 && <= 3:
        return 'Partly Cloudy';
      case >= 45 && <= 48:
        return 'Foggy';
      case >= 51 && <= 67:
        return 'Rainy';
      case >= 71 && <= 77:
        return 'Snowy';
      case >= 80 && <= 99:
        return 'Stormy';
      default:
        return 'Unknown';
    }
  }
}
