import 'package:geolocator/geolocator.dart';

abstract class IGpsDeviceDataSource {
  Future<Position> getPosition();
}
