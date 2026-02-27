import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sunny_or_not/core/error/exceptions.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/location/data/data_sources/i_location_data_source.dart';
import 'package:sunny_or_not/features/location/data/dtos/location_dto.dart';
import 'package:sunny_or_not/features/location/data/repositories/location_repository.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';

class MockLocationDataSource extends Mock implements ILocationDataSource {}

void main() {
  late LocationRepository repository;
  late MockLocationDataSource mockLocationDataSource;

  setUp(() {
    mockLocationDataSource = MockLocationDataSource();
    repository = LocationRepository(mockLocationDataSource);
  });

  const tCity = 'London';
  const tLatitude = 10.0;
  const tLongitude = 20.0;

  group(
    'getLocation',
    () {
      final tLocationDTO = LocationDTO(
        name: tCity,
        latitude: tLatitude,
        longitude: tLongitude,
      );
      const tLocation = Location(
        name: tCity,
        latitude: tLatitude,
        longitude: tLongitude,
      );

      test(
        'Should return Location when the call to remote data source is successful',
        () async {
          // arrange
          when(
            () => mockLocationDataSource.searchCity(tCity),
          ).thenAnswer((_) async => tLocationDTO);

          // act
          final result = await repository.getLocation(tCity);

          // assert
          expect(result, const Right(tLocation));
          verify(
            () => mockLocationDataSource.searchCity(tCity),
          ).called(1);
          verifyNoMoreInteractions(mockLocationDataSource);
        },
      );

      test(
        'Should return LocationNotFoundFailure when the call to remote data source throws a EmptyResultException',
        () async {
          // arrange
          when(
            () => mockLocationDataSource.searchCity(tCity),
          ).thenThrow(NetworkException());

          // act
          final result = await repository.getLocation(tCity);

          // assert
          expect(result, const Left(ConnectionFailure()));
          verify(
            () => mockLocationDataSource.searchCity(tCity),
          ).called(1);
          verifyNoMoreInteractions(mockLocationDataSource);
        },
      );

      test(
        'Should return ConnectionFailure when the call to remote data source throws a NetworkException',
        () async {
          // arrange
          when(
            () => mockLocationDataSource.searchCity(tCity),
          ).thenThrow(NetworkException());

          // act
          final result = await repository.getLocation(tCity);

          // assert
          expect(result, const Left(ConnectionFailure()));
          verify(
            () => mockLocationDataSource.searchCity(tCity),
          ).called(1);
          verifyNoMoreInteractions(mockLocationDataSource);
        },
      );

      test(
        'Should return ServerFailure when the call to remote data source throws a ServerException',
        () async {
          // arrange
          when(
            () => mockLocationDataSource.searchCity(tCity),
          ).thenThrow(ServerException());

          // act
          final result = await repository.getLocation(tCity);

          // assert
          expect(result, const Left(ServerFailure()));
          verify(
            () => mockLocationDataSource.searchCity(tCity),
          ).called(1);
          verifyNoMoreInteractions(mockLocationDataSource);
        },
      );

      test(
        'Should return UnexpectedFailure when the call to remote data source throws any other Exception',
        () async {
          // arrange
          when(
            () => mockLocationDataSource.searchCity(tCity),
          ).thenThrow(Exception());

          // act
          final result = await repository.getLocation(tCity);

          // assert
          expect(result, const Left(UnexpectedFailure()));
          verify(
            () => mockLocationDataSource.searchCity(tCity),
          ).called(1);
          verifyNoMoreInteractions(mockLocationDataSource);
        },
      );
    },
  );
}
