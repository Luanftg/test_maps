import '../../../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    required int id,
    required String device,
    required bool finished,
    required double latitude,
    required double longitude,
  }) : super(
          id: id,
          device: device,
          latitude: latitude,
          longitude: longitude,
          finished: finished,
        );

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      device: json['device'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      finished: json['finished'],
    );
  }
}
