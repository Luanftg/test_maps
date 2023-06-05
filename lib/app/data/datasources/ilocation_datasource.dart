import '../../presentation/pages/map/models/location_model.dart';

abstract class ILocationDatasource {
  Stream<LocationModel> get();
}
