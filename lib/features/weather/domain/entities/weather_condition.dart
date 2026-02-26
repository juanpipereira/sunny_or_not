enum WeatherCondition {
  sunny('Sunny'),
  cloudy('Partly Cloudy'),
  foggy('Foggy'),
  rainy('Rainy'),
  snowy('Snowy'),
  stormy('Stormy'),
  unknown('Unknown');

  final String description;

  const WeatherCondition(this.description);

  static WeatherCondition fromCode(int code) => switch (code) {
        0 => WeatherCondition.sunny,
        >= 1 && <= 3 => WeatherCondition.cloudy,
        >= 45 && <= 48 => WeatherCondition.foggy,
        >= 51 && <= 67 => WeatherCondition.rainy,
        >= 71 && <= 77 => WeatherCondition.snowy,
        >= 80 && <= 99 => WeatherCondition.stormy,
        _ => WeatherCondition.unknown,
      };
}
