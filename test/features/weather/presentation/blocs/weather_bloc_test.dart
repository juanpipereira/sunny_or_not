import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/weather_condition.dart';
import 'package:sunny_or_not/features/weather/domain/use_cases/get_current_weather_use_case.dart';
import 'package:sunny_or_not/features/weather/domain/use_cases/get_weekly_weather_use_case.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_bloc.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_event.dart';
import 'package:sunny_or_not/features/weather/presentation/blocs/weather_state.dart';

class MockGetCurrentWeatherUseCase extends Mock
    implements GetCurrentWeatherUseCase {}

class MockGetWeeklyWeatherUseCase extends Mock
    implements GetWeeklyWeatherUseCase {}

void main() {
  late WeatherBloc weatherBloc;
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late MockGetWeeklyWeatherUseCase mockGetWeeklyWeatherUseCase;

  final getIt = GetIt.instance;

  const tLatitude = 10.0;
  const tLongitude = 20.0;
  const tCity = 'London';
  const tCurrentWeather = CurrentWeather(
    temperature: 20.0,
    weatherCondition: WeatherCondition.cloudy,
  );
  final tWeeklyWeather = [
    DailyWeather(
      maxTemperature: 20.0,
      minTemperature: 20.0,
      weatherCondition: WeatherCondition.cloudy,
      date: DateTime.now(),
    ),
  ];

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    mockGetWeeklyWeatherUseCase = MockGetWeeklyWeatherUseCase();

    getIt.allowReassignment = true;
    getIt.registerLazySingleton<GetCurrentWeatherUseCase>(
        () => mockGetCurrentWeatherUseCase);
    getIt.registerLazySingleton<MockGetWeeklyWeatherUseCase>(
        () => mockGetWeeklyWeatherUseCase);

    weatherBloc = WeatherBloc(
      getCurrentWeather: getIt<GetCurrentWeatherUseCase>(),
      getWeeklyWeather: getIt<MockGetWeeklyWeatherUseCase>(),
    );
  });

  tearDown(() {
    weatherBloc.close();
    getIt.reset();
  });

  group('WeatherBloc Tests', () {
    test('initial state should be WeatherInitial', () {
      expect(weatherBloc.state, equals(WeatherInitial()));
    });

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoadInProgress, WeatherLoadSuccess] when GetCurrentWeather and GetWeeklyWeather are successful',
      build: () {
        when(() => mockGetCurrentWeatherUseCase.execute(
              latitude: tLatitude,
              longitude: tLongitude,
            )).thenAnswer((_) async => const Right(tCurrentWeather));
        when(() => mockGetWeeklyWeatherUseCase.execute(
              latitude: tLatitude,
              longitude: tLongitude,
            )).thenAnswer((_) async => Right(tWeeklyWeather));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(
        const WeatherFetchedByCoordinates(
          latitude: tLatitude,
          longitude: tLongitude,
          cityName: tCity,
        ),
      ),
      expect: () => [
        isA<WeatherLoadInProgress>(),
        isA<WeatherLoadSuccess>()
            .having((s) => s.currentWeather, 'currentWeather', tCurrentWeather)
            .having((s) => s.forecast, 'forecast', tWeeklyWeather),
      ],
      verify: (_) {
        verify(
          () => mockGetCurrentWeatherUseCase.execute(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verify(
          () => mockGetWeeklyWeatherUseCase.execute(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoadInProgress, WeatherLoadFailure] when GetWeeklyWeather fails',
      build: () {
        when(() => mockGetCurrentWeatherUseCase.execute(
              latitude: tLatitude,
              longitude: tLongitude,
            )).thenAnswer((_) async => const Left(UnexpectedFailure()));
        when(() => mockGetWeeklyWeatherUseCase.execute(
              latitude: tLatitude,
              longitude: tLongitude,
            )).thenAnswer((_) async => Right(tWeeklyWeather));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(
        const WeatherFetchedByCoordinates(
          latitude: tLatitude,
          longitude: tLongitude,
          cityName: tCity,
        ),
      ),
      expect: () => [
        isA<WeatherLoadInProgress>(),
        isA<WeatherLoadFailure>().having((s) => s.message, 'message',
            contains(const UnexpectedFailure().message)),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoadInProgress, WeatherLoadFailure] when GetCurrentWeather fails',
      build: () {
        when(() => mockGetCurrentWeatherUseCase.execute(
              latitude: tLatitude,
              longitude: tLongitude,
            )).thenAnswer((_) async => const Right(tCurrentWeather));
        when(() => mockGetWeeklyWeatherUseCase.execute(
              latitude: tLatitude,
              longitude: tLongitude,
            )).thenAnswer((_) async => const Left(UnexpectedFailure()));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(
        const WeatherFetchedByCoordinates(
          latitude: tLatitude,
          longitude: tLongitude,
          cityName: tCity,
        ),
      ),
      expect: () => [
        isA<WeatherLoadInProgress>(),
        isA<WeatherLoadFailure>().having((s) => s.message, 'message',
            contains(const UnexpectedFailure().message)),
      ],
    );
  });
}
