import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _current = const LatLng(22.54481831, 88.3403691);
  Set<Marker> _markers = {};
  bool _mapload = true;

  void _onMapCreated(_controller) {
    setState(() {
      _mapload = false;
      _markers.add(const Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(22.5448131, 88.3403391),
          infoWindow: InfoWindow(title: 'Name', snippet: 'Description')));

      _markers.add(const Marker(
          markerId: MarkerId('id-2'),
          position: LatLng(22.5459931, 88.3403285),
          infoWindow: InfoWindow(title: 'Name', snippet: 'Description')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (_mapload) ? const Loading() : Container(),
        GoogleMap(
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _current,
            zoom: 16,
          ),
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
      ],
    );
  }
}
