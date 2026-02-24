import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sunny_or_not/features/location/data/data_sources/i_location_data_source.dart';
import 'package:sunny_or_not/features/location/data/dtos/location_dto.dart';

class LocationRemoteDataSource implements ILocationDataSource {
  final http.Client client;

  LocationRemoteDataSource({required this.client});

  @override
  Future<LocationDTO> searchCity(String cityName) async {
    // Uri.https to handle encoding spaces
    final url = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
    ).replace(
      queryParameters: {
        'name': cityName,
        'count': '1',
        'language': 'en',
        'format': 'json',
      },
    );

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['results'] == null || (data['results'] as List).isEmpty) {
          throw Exception('City not found');
        }

        return LocationDTO.fromJson(data);
      } else {
        throw Exception('Geocoding API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
