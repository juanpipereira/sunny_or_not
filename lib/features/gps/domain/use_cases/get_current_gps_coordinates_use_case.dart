import 'package:sunny_or_not/features/gps/domain/entities/gps_coordinates.dart';
import 'package:sunny_or_not/features/gps/domain/repositories/i_gps_repository.dart';

class GetCurrentCoordinatesUseCase {
  final IGpsRepository repository;
  GetCurrentCoordinatesUseCase(this.repository);

  Future<GpsCoordinates> execute() async {
    return await repository.getCurrentCoordinates();
  }
}
