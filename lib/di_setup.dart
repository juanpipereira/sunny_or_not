import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sunny_or_not/features/weather/data/data_sources/weather_remote_data_source.dart';
import 'package:sunny_or_not/features/weather/data/repositories/weather_repository.dart';
import 'package:sunny_or_not/features/weather/domain/use_cases/get_current_weather_use_case.dart';
import 'package:sunny_or_not/features/weather/domain/use_cases/get_weekly_weather_use_case.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_bloc.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  // ---------------------------------------------------------------------------
  // FEATURE: WEATHER
  // --------------------------------------------------------------------------

  // Bloc
  getIt.registerFactory(() => WeatherBloc(
        getCurrentWeather: getIt(),
        getWeeklyWeather: getIt(),
      ));

  // Use Cases
  getIt.registerLazySingleton(() => GetCurrentWeatherUseCase(getIt()));
  getIt.registerLazySingleton(() => GetWeeklyWeatherUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepository(getIt()),
  );

  // Data Source
  getIt.registerLazySingleton(
    () => WeatherRemoteDataSource(client: getIt()),
  );

  // ---------------------------------------------------------------------------
  // EXTERNAL
  // ---------------------------------------------------------------------------

  // http.Client
  getIt.registerLazySingleton(() => http.Client());
}
