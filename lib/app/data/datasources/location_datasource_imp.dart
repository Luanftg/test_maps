import 'package:server_sent_events/server_sent_events.dart';

import 'ilocation_datasource.dart';
import '../../presentation/pages/map/models/location_model.dart';

class LocationDatasource implements ILocationDatasource {
  final SseAdapter _sseAdapter;

  LocationDatasource({
    required SseAdapter sseAdapter,
  }) : _sseAdapter = sseAdapter;

  @override
  Stream<LocationModel> get() async* {
    final request = await _sseAdapter.connect(
      baseUrl: '34.125.68.12:8080',
      path: '/events',
      method: SseMethod.GET,
    );

    yield* request.stream.map(
      (data) {
        var result = LocationModel.fromJson(data);
        print('**RESULT: $result ***');
        return result;
      },
    );
  }
}
