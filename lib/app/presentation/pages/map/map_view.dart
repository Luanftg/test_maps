import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:server_sent_events/server_sent_events.dart';

import '../../../data/datasources/location_datasource_imp.dart';
import 'models/location_model.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  StreamSubscription? _locationSubscription;

  final LocationDatasource _locationTracker = LocationDatasource(
    sseAdapter: EventsourceSseAdapterImpl(),
  );

  Marker? marker;
  Circle? circle;
  GoogleMapController? _controller;

  static const CameraPosition _kHouse = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(-23.1630395, -45.895025),
    zoom: 14.4746,
    tilt: 59.440717697143555,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: Set.of((marker != null) ? [marker!] : []),
        circles: Set.of((circle != null) ? [circle!] : []),
        initialCameraPosition: _kHouse,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getCurrentLocation,
        label: const Text('To Home!'),
        icon: const Icon(Icons.home),
      ),
    );
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/images/car.png');
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      LocationModel newLocationData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocationData.latitude, newLocationData.longitude);
    setState(() {
      marker = Marker(
        markerId: const MarkerId('home'),
        position: latlng,
        rotation: 2,
        draggable: false,
        zIndex: 2,
        flat: false,
        anchor: const Offset(0.5, 0.5),
      );
      circle = Circle(
        circleId: const CircleId('car'),
        radius: 7,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latlng,
        fillColor: Colors.blue.withAlpha(70),
      );
    });
  }

  void _getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      _locationSubscription = _locationTracker.get().listen((newLocation) {
        print('****** NEWLOCATION: ${newLocation.toString()} ***');
        if (_controller != null) {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                // bearing: 220.83,
                tilt: 2,
                zoom: 18.0,
                target: LatLng(newLocation.latitude, newLocation.longitude),
              ),
            ),
          );
          updateMarkerAndCircle(newLocation, imageData);
          if (newLocation.finished) {
            _locationSubscription!.cancel();
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
}
