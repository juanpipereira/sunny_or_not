import 'package:flutter/material.dart';
import 'package:sunny_or_not/core/theme/gradient_theme.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/presentation/mappers/weather_condition_ui_mapper.dart';

class ForecastCard extends StatelessWidget {
  final DailyWeather daily;

  const ForecastCard({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: Theme.of(context).extension<GradientTheme>()?.mainGradient,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '${daily.date.day}/${daily.date.month}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              daily.weatherCondition.getIcon,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 28,
            ),
          ),
          Expanded(
            child: Text(
              daily.weatherCondition.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${daily.maxTemperature}°',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${daily.minTemperature}°',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
