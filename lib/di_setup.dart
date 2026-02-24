import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sunny_or_not/features/gps/data/data_sources/gps_device_data_source.dart';
import 'package:sunny_or_not/features/gps/data/data_sources/i_gps_device_data_source.dart';
import 'package:sunny_or_not/features/gps/data/repositories/gps_repository.dart';
import 'package:sunny_or_not/features/gps/domain/repositories/i_gps_repository.dart';
import 'package:sunny_or_not/features/gps/domain/use_cases/get_current_gps_coordinates_use_case.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/location/data/data_sources/i_location_data_source.dart';
import 'package:sunny_or_not/features/location/data/data_sources/location_remote_data_source.dart';
import 'package:sunny_or_not/features/location/data/repositories/location_repository.dart';
import 'package:sunny_or_not/features/location/domain/repositories/i_location_repository.dart';
import 'package:sunny_or_not/features/location/domain/use_cases/get_location_use_case.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_bloc.dart';
import 'package:sunny_or_not/features/weather/data/data_sources/i_weather_data_source.dart';
import 'package:sunny_or_not/features/weather/data/data_sources/weather_remote_data_source.dart';
import 'package:sunny_or_not/features/weather/data/repositories/weather_repository.dart';
import 'package:sunny_or_not/features/weather/domain/repositories/i_weather_repository.dart';
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
  getIt.registerLazySingleton<IWeatherRepository>(
    () => WeatherRepository(getIt()),
  );

  // Data Source
  getIt.registerLazySingleton<IWeatherDataSource>(
    () => WeatherRemoteDataSource(client: getIt()),
  );

  // ---------------------------------------------------------------------------
  // FEATURE: GPS
  // --------------------------------------------------------------------------

  // Bloc
  getIt.registerFactory(() => GpsBloc(getGpsCoordinates: getIt()));

  // Use Case
  getIt.registerLazySingleton(() => GetCurrentCoordinatesUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<IGpsRepository>(
    () => GpsRepository(getIt()),
  );

  // Data Source
  getIt
      .registerLazySingleton<IGpsDeviceDataSource>(() => GpsDeviceDataSource());

  // ---------------------------------------------------------------------------
  // FEATURE: LOCATION
  // --------------------------------------------------------------------------

  // Bloc
  getIt.registerFactory(() => LocationBloc(
        getLocation: getIt(),
      ));

  // Use Case
  getIt.registerLazySingleton(() => GetLocationUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<ILocationRepository>(
    () => LocationRepository(getIt()),
  );

  // Data Source
  getIt.registerLazySingleton<ILocationDataSource>(
    () => LocationRemoteDataSource(client: getIt()),
  );

  // ---------------------------------------------------------------------------
  // EXTERNAL
  // ---------------------------------------------------------------------------

  // http.Client
  getIt.registerLazySingleton(() => http.Client());
}
