import 'package:flutter/material.dart';
import 'package:sunny_or_not/core/theme/gradient_theme.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/presentation/mappers/weather_condition_ui_mapper.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather currentWeather;
  final String cityName;

  const CurrentWeatherCard({
    super.key,
    required this.currentWeather,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: Theme.of(context).extension<GradientTheme>()?.mainGradient,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            currentWeather.weatherCondition.getIcon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 40,
          ),
          const SizedBox(height: 4),
          Text(
            cityName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${currentWeather.temperature}°C',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            currentWeather.weatherCondition.description,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
