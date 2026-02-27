import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sunny_or_not/core/error/exceptions.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/gps/data/data_sources/i_gps_device_data_source.dart';
import 'package:sunny_or_not/features/gps/data/repositories/gps_repository.dart';
import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';

class MockGpsDeviceDataSource extends Mock implements IGpsDeviceDataSource {}

void main() {
  late GpsRepository repository;
  late MockGpsDeviceDataSource mockGpsDeviceDataSource;

  setUp(() {
    mockGpsDeviceDataSource = MockGpsDeviceDataSource();
    repository = GpsRepository(mockGpsDeviceDataSource);
  });

  const tLatitude = 10.0;
  const tLongitude = 20.0;

  group(
    'getCurrentCoordinates',
    () {
      final tPosition = Position(
        longitude: tLongitude,
        latitude: tLatitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
      const tGpsCoordinates = GpsCoordinates(
        latitude: tLatitude,
        longitude: tLongitude,
      );

      test(
        'Should return GpsCoordinates when the call to device data source is successful',
        () async {
          // arrange
          when(
            () => mockGpsDeviceDataSource.getPosition(),
          ).thenAnswer((_) async => tPosition);

          // act
          final result = await repository.getCurrentCoordinates();

          // assert
          expect(result, const Right(tGpsCoordinates));
          verify(
            () => mockGpsDeviceDataSource.getPosition(),
          ).called(1);
          verifyNoMoreInteractions(mockGpsDeviceDataSource);
        },
      );

      test(
        'Should return GpsPermissionFailure when the call to device data source throws a PermissionException',
        () async {
          // arrange
          when(
            () => mockGpsDeviceDataSource.getPosition(),
          ).thenThrow(PermissionException());

          // act
          final result = await repository.getCurrentCoordinates();

          // assert
          expect(result, const Left(GpsPermissionFailure()));
          verify(
            () => mockGpsDeviceDataSource.getPosition(),
          ).called(1);
          verifyNoMoreInteractions(mockGpsDeviceDataSource);
        },
      );

      test(
        'Should return UnexpectedFailure when the call to device data source throws any other Exception',
        () async {
          // arrange
          when(
            () => mockGpsDeviceDataSource.getPosition(),
          ).thenThrow(Exception());

          // act
          final result = await repository.getCurrentCoordinates();

          // assert
          expect(result, const Left(UnexpectedFailure()));
          verify(
            () => mockGpsDeviceDataSource.getPosition(),
          ).called(1);
          verifyNoMoreInteractions(mockGpsDeviceDataSource);
        },
      );
    },
  );
}
