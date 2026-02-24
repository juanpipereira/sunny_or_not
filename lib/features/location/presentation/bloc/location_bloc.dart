import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/features/location/domain/use_cases/get_location_use_case.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_event.dart';
import 'package:sunny_or_not/features/location/presentation/bloc/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocationUseCase getLocation;

  LocationBloc({
    required this.getLocation,
  }) : super(LocationInitial()) {
    on<LocationCitySearched>(_onLocationCitySearched);
  }

  Future<void> _onLocationCitySearched(
    LocationCitySearched event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoadInProgress());

    try {
      final location = await getLocation.execute(event.cityName);
      emit(LocationLoadSuccess(location));
    } catch (e) {
      emit(LocationLoadFailure(e.toString()));
    }
  }
}
