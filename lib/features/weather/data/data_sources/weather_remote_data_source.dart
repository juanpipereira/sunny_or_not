import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sunny_or_not/features/weather/data/data_sources/i_weather_data_source.dart';
import 'package:sunny_or_not/features/weather/data/dtos/weather_dto.dart';
import 'package:sunny_or_not/features/weather/data/dtos/weekly_weather_dto.dart';

class WeatherRemoteDataSource implements IWeatherDataSource {
  final http.Client client;

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  WeatherRemoteDataSource({required this.client});

  @override
  Future<WeatherDTO> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current_weather': true,
      },
    );

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return WeatherDTO.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Error fetching today\'s weather. API Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching today\'s weather: $e');
    }
  }

  @override
  Future<WeeklyWeatherDTO> getWeeklyWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'daily': 'temperature_2m_max,temperature_2m_min,weathercode',
        'forecast_days': 10,
        'timezone': 'auto',
      },
    );
    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return WeeklyWeatherDTO.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Error fetching weekly weather. API Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weekly weather: $e');
    }
  }
}
