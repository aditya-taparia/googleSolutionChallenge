import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:googlesolutionchallenge/widgets/loading.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late LocationPermission permission;
  final LatLng _current = const LatLng(10.8505, 76.2711);
  final Set<Marker> _markers = {};
  bool _mapload = true;
  bool showgeolocationwidget = false;

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

  // 1cs 2ls 3ir 4jr
  List<bool> showmarkertype = [false, false, false, true];
  List<LatLng> ll = [];
  List<Map> userList = [];
  //map window
  double _height = 100;
  bool _open = false;
  bool _markerclicked = false;

  void getdata() async {
    final Future<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('Mapdata').get();
    _usersStream.then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> val = element.data() as Map<String, dynamic>;
        userList.add(val);
        print(element.data());
      });
    });
  }

  void _onMapCreated(_controller) {
    setState(() {
      _mapload = false;
      userList.forEach((element) {
        _markers.add(
          Marker(
            markerId: MarkerId('id-1' + element.toString()),
            position: LatLng(
                double.parse(element["location"].latitude.toString()),
                double.parse(element["location"].longitude.toString())),
            onTap: () {
              setState(() {
                _markerclicked = true;
              });
            },
            infoWindow: InfoWindow(
              title: element["name"],
              snippet: 'Item/service Name',
            ),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
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
              zoom: 5,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  onSaved: (value) {},
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.location_on),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText:
                          "Search for Items, Spaces, Jobs, Community service near you",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                ),
              ),
              showmarkertype[0]
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: SizedBox(
                        height: 25,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  getnearbylocations("Orphanages", _current);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(66, 103, 178, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Orphanages",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  getnearbylocations("old+age+homes", _current);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(66, 103, 178, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Old Age Homes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  getnearbylocations("NGO", _current);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(66, 103, 178, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Non Government Organisations",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.bottomRight,
              child: SpeedDial(
                animatedIcon: AnimatedIcons.menu_home,
                overlayOpacity: 0,
                children: [
                  SpeedDialChild(
                      backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
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
                          // 1cs 2ls 3ir 4jr
                          showmarkertype = [false, false, false, true];
                        });
                      }),
                  SpeedDialChild(
                      backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
                      label: "Items Requests",
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(66, 103, 178, 1),
                      ),
                      child: const Icon(Icons.handyman, color: Colors.white),
                      onTap: () {
                        setState(() {
                          // 1cs 2ls 3ir 4jr
                          showmarkertype = [false, false, true, false];
                        });
                      }),
                  SpeedDialChild(
                      backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
                      label: "LinkSpace",
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(66, 103, 178, 1),
                      ),
                      child: const Icon(Icons.group, color: Colors.white),
                      onTap: () {
                        setState(() {
                          // 1cs 2ls 3ir 4jr
                          showmarkertype = [false, true, false, false];
                        });
                      }),
                  SpeedDialChild(
                      backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
                      label: "Community Service",
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(66, 103, 178, 1),
                      ),
                      child: const Icon(Icons.handshake, color: Colors.white),
                      onTap: () {
                        setState(() {
                          // 1cs 2ls 3ir 4jr
                          showmarkertype = [true, false, false, false];
                        });
                      }),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 80, 8),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
                onPressed: () => getLocation(),
                child: const Icon(Icons.gps_fixed)),
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
      ],
    );
  }

  getLocation() async {
    print("called");
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final position = await Geolocator.getCurrentPosition();
    print(position);
  }

  getnearbylocations(String locationtype, LatLng current) async {}
}
