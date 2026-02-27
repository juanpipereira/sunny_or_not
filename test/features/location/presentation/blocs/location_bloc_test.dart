import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sunny_or_not/core/error/failures.dart';
import 'package:sunny_or_not/features/location/domain/entities/location.dart';
import 'package:sunny_or_not/features/location/domain/use_cases/get_location_use_case.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_bloc.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_event.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_state.dart';

class MockGetLocationUseCase extends Mock implements GetLocationUseCase {}

void main() {
  late LocationBloc locationBloc;
  late MockGetLocationUseCase mockGetLocationUseCase;
  final getIt = GetIt.instance;

  const tCity = 'London';
  const tLatitude = 10.0;
  const tLongitude = 20.0;

  const tLocation = Location(
    name: tCity,
    latitude: tLatitude,
    longitude: tLongitude,
  );

  setUp(() {
    getIt.allowReassignment = true;
    mockGetLocationUseCase = MockGetLocationUseCase();
    getIt.registerLazySingleton<GetLocationUseCase>(
        () => mockGetLocationUseCase);

    locationBloc = LocationBloc(getLocation: getIt<GetLocationUseCase>());
  });

  tearDown(() {
    locationBloc.close();
    getIt.reset();
  });

  group('LocationBloc Tests', () {
    test('Initial state should be LocationInitial', () {
      expect(locationBloc.state, equals(LocationInitial()));
    });

    blocTest<LocationBloc, LocationState>(
      'Should emit [LocationLoadInProgress, LocationLoadSuccess] when data is fetched successfully',
      build: () {
        when(() => mockGetLocationUseCase.execute(tCity))
            .thenAnswer((_) async => const Right(tLocation));
        return locationBloc;
      },
      act: (bloc) => bloc.add(const LocationCitySearched(tCity)),
      expect: () => [
        isA<LocationLoadInProgress>(),
        isA<LocationLoadSuccess>()
            .having((s) => s.location, 'location', tLocation),
      ],
      verify: (_) {
        verify(() => mockGetLocationUseCase.execute(tCity)).called(1);
      },
    );

    blocTest<LocationBloc, LocationState>(
      'Should emit [LocationLoadInProgress, LocationLoadFailure] when fetching data fails',
      build: () {
        when(() => mockGetLocationUseCase.execute(tCity))
            .thenAnswer((_) async => const Left(UnexpectedFailure()));
        return locationBloc;
      },
      act: (bloc) => bloc.add(const LocationCitySearched(tCity)),
      expect: () => [
        isA<LocationLoadInProgress>(),
        isA<LocationLoadFailure>().having((s) => s.message, 'message',
            contains(const UnexpectedFailure().message)),
      ],
    );
  });
}
