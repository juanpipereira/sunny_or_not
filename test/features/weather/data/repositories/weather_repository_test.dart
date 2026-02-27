import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sunny_or_not/core/error/exceptions.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/weather/data/data_sources/i_weather_data_source.dart';
import 'package:sunny_or_not/features/weather/data/dtos/weather_dto.dart';
import 'package:sunny_or_not/features/weather/data/dtos/weekly_weather_dto.dart';
import 'package:sunny_or_not/features/weather/data/repositories/weather_repository.dart';
import 'package:sunny_or_not/features/weather/domain/entities/current_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/daily_weather.dart';
import 'package:sunny_or_not/features/weather/domain/entities/weather_condition.dart';

class MockWeatherDataSource extends Mock implements IWeatherDataSource {}

void main() {
  late WeatherRepository repository;
  late MockWeatherDataSource mockWeatherDataSource;

  setUp(() {
    mockWeatherDataSource = MockWeatherDataSource();
    repository = WeatherRepository(mockWeatherDataSource);
  });

  const tLatitude = 10.0;
  const tLongitude = 20.0;

  group('getCurrentWeather', () {
    const tCurrentWeatherDTO = WeatherDTO(
      temperature: 25.0,
      weatherCode: 0,
    );
    final tCurrentWeather = CurrentWeather(
      temperature: 25.0,
      weatherCondition: WeatherCondition.fromCode(0),
    );

    test(
      'Should return CurrentWeather when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenAnswer((_) async => tCurrentWeatherDTO);

        // act
        final result = await repository.getCurrentWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, Right(tCurrentWeather));
        verify(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );

    test(
      'Should return ConnectionFailure when the call to remote data source throws a NetworkException',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenThrow(NetworkException());

        // act
        final result = await repository.getCurrentWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, const Left(ConnectionFailure()));
        verify(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );

    test(
      'Should return ServerFailure when the call to remote data source throws a ServerException',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenThrow(ServerException());

        // act
        final result = await repository.getCurrentWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, const Left(ServerFailure()));
        verify(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );

    test(
      'Should return UnexpectedFailure when the call to remote data source throws any other Exception',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenThrow(Exception());

        // act
        final result = await repository.getCurrentWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, const Left(UnexpectedFailure()));
        verify(
          () => mockWeatherDataSource.getCurrentWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );
  });

  group('getWeeklyWeather', () {
    final tDailyWeatherDTO = WeeklyWeatherDTO(
      dates: [DateTime(2026, 1, 1).toIso8601String()],
      maxTemperatures: [25.0],
      minTemperatures: [10.0],
      weatherCodes: [0],
    );
    final tDailyWeather = DailyWeather(
      maxTemperature: tDailyWeatherDTO.maxTemperatures.first,
      minTemperature: tDailyWeatherDTO.minTemperatures.first,
      date: DateTime.parse(tDailyWeatherDTO.dates.first),
      weatherCondition:
          WeatherCondition.fromCode(tDailyWeatherDTO.weatherCodes.first),
    );
    final tListDailyWeather = [tDailyWeather];

    test(
      'Should return List<DailyWeather> when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenAnswer((_) async => tDailyWeatherDTO);

        // act
        final weeklyWeatherEither = await repository.getWeeklyWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        weeklyWeatherEither.fold(
          (_) => fail('Should not got Left'),
          (result) => expect(result, tListDailyWeather),
        );
        verify(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );

    test(
      'Should return ConnectionFailure when the call to remote data source throws a NetworkException',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenThrow(NetworkException());

        // act
        final result = await repository.getWeeklyWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, const Left(ConnectionFailure()));
        verify(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );

    test(
      'Should return ServerFailure when the call to remote data source throws a ServerException',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenThrow(ServerException());

        // act
        final result = await repository.getWeeklyWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, const Left(ServerFailure()));
        verify(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );

    test(
      'should return UnexpectedFailure when the call to remote data source throws any other Exception',
      () async {
        // arrange
        when(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).thenThrow(Exception());

        // act
        final result = await repository.getWeeklyWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(result, const Left(UnexpectedFailure()));
        verify(
          () => mockWeatherDataSource.getWeeklyWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockWeatherDataSource);
      },
    );
  });
}
