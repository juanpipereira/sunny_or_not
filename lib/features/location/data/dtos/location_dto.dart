class LocationDTO {
  final String name;
  final double latitude;
  final double longitude;

  LocationDTO({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory LocationDTO.fromJson(Map<String, dynamic> json) {
    final List results = json['results'] ?? [];
    if (results.isEmpty) throw Exception('City not found');

    final first = results.first;
    return LocationDTO(
      name: first['name'] as String,
      latitude: (first['latitude'] as num).toDouble(),
      longitude: (first['longitude'] as num).toDouble(),
    );
  }
}
