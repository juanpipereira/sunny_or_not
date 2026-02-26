import 'package:sunny_or_not/features/weather/data/dtos/weather_dto.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/weather_condition.dart';

extension WeatherDtoMapper on WeatherDTO {
  CurrentWeather toEntity() {
    return CurrentWeather(
      temperature: temperature,
      weatherCondition: WeatherCondition.fromCode(weatherCode),
    );
  }
}
