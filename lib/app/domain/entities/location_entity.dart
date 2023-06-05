class LocationEntity {
  final int id;
  final String device;
  final double latitude;
  final double longitude;
  final bool finished;

  LocationEntity({
    required this.id,
    required this.device,
    required this.latitude,
    required this.longitude,
    required this.finished,
  });

  @override
  String toString() {
    return 'LocationEntity(id: $id, device: $device, latitude: $latitude, longitude: $longitude, finished: $finished)';
  }
}
