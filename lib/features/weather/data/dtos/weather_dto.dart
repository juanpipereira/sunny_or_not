class WeatherDTO {
  final double temperature;
  final int weatherCode;

  const WeatherDTO({required this.temperature, required this.weatherCode});

  factory WeatherDTO.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'] as Map<String, dynamic>;
    return WeatherDTO(
      temperature: (current['temperature'] as num).toDouble(),
      weatherCode: current['weathercode'] as int,
    );
  }
}
