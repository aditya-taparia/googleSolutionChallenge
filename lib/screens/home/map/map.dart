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
  Completer<GoogleMapController> controller = Completer();
  final LatLng _current = const LatLng(22.54481831, 88.3403691);
  final Set<Marker> _markers = {};
  bool _mapload = true;

  //map window
  double _height = 100;
  bool _open = false;
  bool _markerclicked = false;

  void _onMapCreated(_controller) {
    setState(() {
      _mapload = false;
      _markers.add(
        Marker(
          markerId: const MarkerId('id-1'),
          position: const LatLng(22.5448131, 88.3403391),
          onTap: () {
            setState(() {
              _markerclicked = true;
            });
          },
          infoWindow: const InfoWindow(
            title: 'Name',
            snippet: 'Description',
          ),
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('id-2'),
          position: const LatLng(22.5459931, 88.3403285),
          onTap: () {
            setState(() {
              _markerclicked = true;
            });
          },
          infoWindow: const InfoWindow(
            title: 'Name',
            snippet: 'Description',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (_mapload) ? const Loading() : Container(),
        GestureDetector(
          child: GoogleMap(
            myLocationEnabled: true,
            zoomControlsEnabled: !_markerclicked,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _current,
              zoom: 16,
            ),
            onMapCreated: _onMapCreated,
            onTap: (LatLng latLng) {
              setState(() {
                _markerclicked = false;
              });
            },
            markers: _markers,
          ),
        ),
        _markerclicked
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 500,
                  ),
                  height: _height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_open) {
                          setState(() {
                            _height = 100;
                            _open = false;
                          });
                        } else {
                          setState(() {
                            _height = 300;
                            _open = true;
                          });
                        }
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: !_open
                                  ? const Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 30,
                                    ),
                            ),
                            const Text("Name"),
                            const Text("Description"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            : Container(),
      ],
    );
  }
}
