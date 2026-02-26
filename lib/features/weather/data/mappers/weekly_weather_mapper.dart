import 'package:sunny_or_not/features/weather/data/dtos/weekly_weather_dto.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/weather_condition.dart';

extension WeeklyWeatherMapper on WeeklyWeatherDTO {
  List<DailyWeather> toEntity() {
    final dailyWeatherList = <DailyWeather>[];
    for (var i = 0; i < dates.length; i++) {
      dailyWeatherList.add(
        DailyWeather(
          maxTemperature: maxTemperatures[i],
          minTemperature: minTemperatures[i],
          date: DateTime.parse(dates[i]),
          weatherCondition: WeatherCondition.fromCode(weatherCodes[i]),
        ),
      );
    }

    return dailyWeatherList;
  }
}
