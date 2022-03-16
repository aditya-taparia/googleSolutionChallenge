import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<bool> check = [false, false, false];

  final Completer<GoogleMapController> _controller = Completer();

  late LocationPermission permission;
  final LatLng _current = const LatLng(15.5057, 80.0499);
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
  BoxDecoration selectedDecoration = BoxDecoration(
    color: const Color.fromRGBO(66, 103, 178, 1),
    borderRadius: BorderRadius.circular(20),
  );
  List<bool> showmarkertype = [false, false, false, true];
  List<bool> isSelected = [true, false, false, false, false];

  List<LatLng> ll = [];
  List<Map> userList = [];
  //map window
  double _height = 100;
  bool _open = false;
  bool _markerclicked = false;
  bool _currentIcon = true;

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
              zoom: 15,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: SizedBox(
                  height: 35,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected.asMap().forEach((index, value) {
                                if (value == true) {
                                  isSelected[index] = false;
                                }
                              });
                              isSelected[0] = true;
                            });
                          },
                          child: Container(
                            width: 70,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: !isSelected[0]
                                ? BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            66, 103, 178, 1),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                : selectedDecoration,
                            child: Center(
                              child: Text(
                                "All",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isSelected[0]
                                      ? const Color.fromRGBO(66, 103, 178, 1)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected.asMap().forEach((index, value) {
                                if (value == true) {
                                  isSelected[index] = false;
                                }
                              });
                              isSelected[1] = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: !isSelected[1]
                                ? BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            66, 103, 178, 1),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                : selectedDecoration,
                            child: Center(
                              child: Text(
                                "Community Service",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isSelected[1]
                                      ? const Color.fromRGBO(66, 103, 178, 1)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected.asMap().forEach((index, value) {
                                if (value == true) {
                                  isSelected[index] = false;
                                }
                              });
                              isSelected[2] = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: !isSelected[2]
                                ? BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            66, 103, 178, 1),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                : selectedDecoration,
                            child: Center(
                              child: Text(
                                "LinkSpaces",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isSelected[2]
                                      ? const Color.fromRGBO(66, 103, 178, 1)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected.asMap().forEach((index, value) {
                                if (value == true) {
                                  isSelected[index] = false;
                                }
                              });
                              isSelected[3] = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: !isSelected[3]
                                ? BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            66, 103, 178, 1),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                : selectedDecoration,
                            child: Center(
                              child: Text(
                                "Item Requests",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isSelected[3]
                                      ? const Color.fromRGBO(66, 103, 178, 1)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected.asMap().forEach((index, value) {
                                if (value == true) {
                                  isSelected[index] = false;
                                }
                              });
                              isSelected[4] = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: !isSelected[4]
                                ? BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            66, 103, 178, 1),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                : selectedDecoration,
                            child: Center(
                              child: Text(
                                "Job Requests",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isSelected[4]
                                      ? const Color.fromRGBO(66, 103, 178, 1)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
        (isSelected[0] | isSelected[1])
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment(1, -0.45),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Center(
                              child: const Text(
                                "Apply Filter",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            content: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GFCheckboxListTile(
                                  position: GFPosition.start,
                                  titleText: 'Orphanages',
                                  size: 25,
                                  activeBgColor: Colors.orangeAccent,
                                  type: GFCheckboxType.square,
                                  activeIcon: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      check[0] = value;
                                    });
                                  },
                                  value: check[0],
                                  inactiveIcon: null,
                                ),
                                GFCheckboxListTile(
                                  position: GFPosition.start,
                                  titleText: 'Old Age Homes',
                                  size: 25,
                                  activeBgColor: Colors.orangeAccent,
                                  type: GFCheckboxType.square,
                                  activeIcon: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      check[1] = value;
                                    });
                                  },
                                  value: check[1],
                                  inactiveIcon: null,
                                ),
                                GFCheckboxListTile(
                                  position: GFPosition.start,
                                  titleText: "NGO's",
                                  size: 25,
                                  activeBgColor: Colors.orangeAccent,
                                  type: GFCheckboxType.square,
                                  activeIcon: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      check[2] = value;
                                    });
                                  },
                                  value: check[2],
                                  inactiveIcon: null,
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              OutlinedButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.varelaRound().fontFamily,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.varelaRound().fontFamily,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                            actionsAlignment: MainAxisAlignment.spaceAround,
                          );
                        }),
                      );
                    },
                    child: Icon(
                      Icons.tune_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ))
            : Container(),
        Padding(
          padding: const EdgeInsets.only(bottom: 70.0, right: 8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
              onPressed: () => getLocation(),
              child: const Icon(
                Icons.add_location_rounded,
                size: 30,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
              onPressed: () {
                _currentIcon ? getLocation() : null;
                setState(() {
                  _currentIcon = !_currentIcon;
                });
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: _currentIcon
                    ? Icon(
                        Icons.gps_not_fixed_rounded,
                        key: const ValueKey('download'),
                      )
                    : Icon(
                        Icons.gps_fixed_rounded,
                        key: const ValueKey('done'),
                      ),
              ),
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
