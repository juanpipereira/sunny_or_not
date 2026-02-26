import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunny_or_not/features/gps/domain/use_cases/get_current_gps_coordinates_use_case.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_event.dart';
import 'package:sunny_or_not/features/gps/presentation/bloc/gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  final GetCurrentCoordinatesUseCase getGpsCoordinates;

  GpsBloc({required this.getGpsCoordinates}) : super(GpsInitial()) {
    on<GpsCoordinatesRequested>(_onGpsCoordinatesRequested);
  }

  Future<void> _onGpsCoordinatesRequested(
    GpsCoordinatesRequested event,
    Emitter<GpsState> emit,
  ) async {
    emit(GpsLoadInProgress());

    final result = await getGpsCoordinates.execute();
    result.fold(
      (failure) => emit(GpsLoadFailure(failure.message)),
      (coordinates) => emit(GpsLoadSuccess(coordinates)),
    );
  }
}
