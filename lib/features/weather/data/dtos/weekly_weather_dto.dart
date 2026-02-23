class WeeklyWeatherDTO {
  final List<String> dates;
  final List<double> maxTemperatures;
  final List<double> minTemperatures;
  final List<int> weatherCodes;

  WeeklyWeatherDTO({
    required this.dates,
    required this.maxTemperatures,
    required this.minTemperatures,
    required this.weatherCodes,
  });

  factory WeeklyWeatherDTO.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>;

    return WeeklyWeatherDTO(
      dates: List<String>.from(daily['time']),
      maxTemperatures: (daily['temperature_2m_max'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      minTemperatures: (daily['temperature_2m_min'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      weatherCodes: List<int>.from(daily['weathercode']),
    );
  }
}
