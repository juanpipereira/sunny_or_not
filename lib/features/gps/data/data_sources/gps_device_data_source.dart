import 'package:geolocator/geolocator.dart';
import 'package:sunny_or_not/core/error/exceptions.dart';
import 'package:sunny_or_not/features/gps/data/data_sources/i_gps_device_data_source.dart';

class GpsDeviceDataSource implements IGpsDeviceDataSource {
  @override
  Future<Position> getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw PermissionException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionException();
    }

    return await Geolocator.getCurrentPosition();
  }
}
