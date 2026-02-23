import 'package:sunny_or_not/features/weather/data/dtos/weekly_weather_dto.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';

extension WeeklyWeatherMapper on WeeklyWeatherDTO {
  List<DailyWeather> toEntity() {
    final dailyWeatherList = <DailyWeather>[];
    for (var i = 0; i < dates.length; i++) {
      dailyWeatherList.add(
        DailyWeather(
          maxTemperature: maxTemperatures[i],
          minTemperature: minTemperatures[i],
          date: DateTime.parse(dates[i]),
          condition: _mapCodeToDescription(weatherCodes[i]),
        ),
      );
    }

    return dailyWeatherList;
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
