import 'package:sunny_or_not/features/weather/data/data_sources/i_weather_data_source.dart';
import 'package:sunny_or_not/features/weather/data/mappers/weather_mapper.dart';
import 'package:sunny_or_not/features/weather/data/mappers/weekly_weather_mapper.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/repositories/i_weather_repository.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherDataSource remoteDataSource;

  WeatherRepository(this.remoteDataSource);

  @override
  Future<CurrentWeather> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherDTO = await remoteDataSource.getCurrentWeather(
      latitude: latitude,
      longitude: longitude,
    );
    return weatherDTO.toEntity();
  }

  @override
  Future<List<DailyWeather>> getWeeklyWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weathersDTO = await remoteDataSource.getWeeklyWeather(
      latitude: latitude,
      longitude: longitude,
    );
    return weathersDTO.toEntity();
  }
}
