import 'package:flutter/material.dart';
import 'package:sunny_or_not/features/weather/domain/entities/weather_condition.dart';

extension WeatherConditionUiMapper on WeatherCondition {
  IconData get getIcon => switch (this) {
        WeatherCondition.sunny => Icons.wb_sunny,
        WeatherCondition.cloudy => Icons.wb_cloudy,
        WeatherCondition.foggy => Icons.blur_on,
        WeatherCondition.rainy => Icons.umbrella,
        WeatherCondition.snowy => Icons.ac_unit,
        WeatherCondition.stormy => Icons.thunderstorm,
        WeatherCondition.unknown => Icons.help_outline,
      };
}
