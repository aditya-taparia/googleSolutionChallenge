import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

// heart symbol
  bool favselect = false;
  Icon fav = const Icon(
    Icons.favorite_border,
    color: Color.fromRGBO(66, 103, 178, 1),
  );
  Icon fav2 = const Icon(
    Icons.favorite,
    color: Color.fromRGBO(66, 103, 178, 1),
  );

  // 1. CS , 2. IR , 3. JR
  List<bool> showmarkertype = [true, true, true];
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
            title: 'User Name',
            snippet: 'Item/service Name',
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
            zoomControlsEnabled: false,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              tilt: 30,
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: TextFormField(
              autofocus: false,
              keyboardType: TextInputType.text,
              onSaved: (value) {},
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Search for Items, Spaces, Jobs",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "ITEM NAME",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromRGBO(66, 103, 178, 1),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            66, 103, 178, 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Category",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: favselect ? fav : fav2,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      favselect = !favselect;
                                    });
                                  },
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Description",
                              style: TextStyle(
                                color: Color.fromRGBO(66, 103, 178, 1),
                              ),
                            ),
                            const Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam posuere ullamcorper varius. Suspendisse id auctor tellus, at imperdiet justo. Mauris vitae orci in odio dapibus consectetur. Etiam convallis lectus felis,"),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 100,
                                  child: const Center(
                                    child: Text("IMAGE 1"),
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(211, 211, 211, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 100,
                                    child: const Center(
                                      child: Text("IMAGE 2"),
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          211, 211, 211, 1),
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                  onPressed: () {}, child: const Text("Chat")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            : Container(),
        !_markerclicked
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: SpeedDial(
                      animatedIcon: AnimatedIcons.menu_home,
                      overlayOpacity: 0,
                      children: [
                        SpeedDialChild(
                            backgroundColor:
                                const Color.fromRGBO(66, 103, 178, 1),
                            label: "Job Requests",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(66, 103, 178, 1),
                            ),
                            child: const Icon(
                              Icons.work,
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                // 1. CS , 2. IR , 3. JR
                                showmarkertype = [false, false, true];
                              });
                            }),
                        SpeedDialChild(
                            backgroundColor:
                                const Color.fromRGBO(66, 103, 178, 1),
                            label: "Items Requests",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(66, 103, 178, 1),
                            ),
                            child:
                                const Icon(Icons.handyman, color: Colors.white),
                            onTap: () {
                              setState(() {
                                // 1. CS , 2. IR , 3. JR
                                showmarkertype = [false, true, false];
                              });
                            }),
                        SpeedDialChild(
                            backgroundColor:
                                const Color.fromRGBO(66, 103, 178, 1),
                            label: "Community Service",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(66, 103, 178, 1),
                            ),
                            child: const Icon(Icons.handshake,
                                color: Colors.white),
                            onTap: () {
                              setState(() {
                                // 1. CS , 2. IR , 3. JR
                                showmarkertype = [true, false, false];
                              });
                            }),
                      ],
                    )),
              )
            : Container(),
      ],
    );
  }
}
