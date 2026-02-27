import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';
import 'package:sunny_or_not/features/gps/domain/use_cases/get_current_gps_coordinates_use_case.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_bloc.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_event.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_state.dart';

class MockGetCurrentCoordinatesUseCase extends Mock
    implements GetCurrentCoordinatesUseCase {}

void main() {
  late GpsBloc gpsBloc;
  late MockGetCurrentCoordinatesUseCase mockGetCurrentCoordinatesUseCase;
  final getIt = GetIt.instance;

  const tLatitude = 10.0;
  const tLongitude = 20.0;
  const tCoordinates = GpsCoordinates(
    latitude: tLatitude,
    longitude: tLongitude,
  );

  setUp(() {
    mockGetCurrentCoordinatesUseCase = MockGetCurrentCoordinatesUseCase();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<GetCurrentCoordinatesUseCase>(
        () => mockGetCurrentCoordinatesUseCase);

    gpsBloc = GpsBloc(getGpsCoordinates: getIt<GetCurrentCoordinatesUseCase>());
  });

  tearDown(() {
    gpsBloc.close();
    getIt.reset();
  });

  group('GpsBloc Tests', () {
    test('Initial state should be GpsInitial', () {
      expect(gpsBloc.state, equals(GpsInitial()));
    });

    blocTest<GpsBloc, GpsState>(
      'Should emit [LocationLoadInProgress, LocationLoadSuccess] when data is fetched successfully',
      build: () {
        when(() => mockGetCurrentCoordinatesUseCase.execute())
            .thenAnswer((_) async => const Right(tCoordinates));
        return gpsBloc;
      },
      act: (bloc) => bloc.add(GpsCoordinatesRequested()),
      expect: () => [
        isA<GpsLoadInProgress>(),
        isA<GpsLoadSuccess>()
            .having((s) => s.gpsCoordinates, 'gpsCoordinates', tCoordinates),
      ],
      verify: (_) {
        verify(() => mockGetCurrentCoordinatesUseCase.execute()).called(1);
      },
    );

    blocTest<GpsBloc, GpsState>(
      'Should emit [LocationLoadInProgress, LocationLoadFailure] when fetching data fails',
      build: () {
        when(() => mockGetCurrentCoordinatesUseCase.execute())
            .thenAnswer((_) async => const Left(GpsPermissionFailure()));
        return gpsBloc;
      },
      act: (bloc) => bloc.add(GpsCoordinatesRequested()),
      expect: () => [
        isA<GpsLoadInProgress>(),
        isA<GpsLoadFailure>().having((s) => s.message, 'message',
            contains(const GpsPermissionFailure().message)),
      ],
    );
  });
}
