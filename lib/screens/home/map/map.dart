import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlesolutionchallenge/screens/utils/notification.dart';

import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late LocationPermission permission;
  List<bool> check = [false, false, false];

  final LatLng _current = const LatLng(15.5057, 80.0499);
  Set<Marker> _markers = {};
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
  List<Map> userList2 = [];
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
        // print(element.data());
      });
    });

    final Future<QuerySnapshot> _users2Stream =
        FirebaseFirestore.instance.collection('Linkspace').get();

    _users2Stream.then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> val = element.data() as Map<String, dynamic>;
        userList2.add(val);
        // print(element.data());
      });
    });
  }

  void setmarkers() {
    _markers = {};

    setState(() {
      //item markers
      if (isSelected[0] || isSelected[3]) {
        userList.forEach((element) {
          if (element["category"].contains("item")) {
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
          }
        });
      }
//Request Markers
      if (isSelected[0] || isSelected[4]) {
        userList.forEach((element) {
          if (element["category"].contains("request")) {
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
          }
        });
      }

//Linkspace markers
      if (isSelected[0] || isSelected[2]) {
        userList2.forEach((element) {
          _markers.add(
            Marker(
              markerId: MarkerId('id-1' + element.toString()),
              position: LatLng(
                  double.parse(element["locality"].latitude.toString()),
                  double.parse(element["locality"].longitude.toString())),
              onTap: () {
                setState(() {
                  _markerclicked = true;
                });
              },
              infoWindow: InfoWindow(
                title: 'LinkSpace',
                snippet: element['location'],
              ),
            ),
          );
        });
      }
    });
  }

  void _onMapCreated(controller) {
    _markers = {};
    _controller.complete(controller);
    setState(() {
      _mapload = false;
    });

    setmarkers();
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
        FloatingSearchBar(
          clearQueryOnClose: true,
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOutCubic,
          physics: const BouncingScrollPhysics(),
          borderRadius: BorderRadius.circular(10),
          elevation: 0,
          border: const BorderSide(
            color: Color.fromRGBO(204, 204, 204, 1),
            width: 1.5,
          ),
          iconColor: Colors.grey[800],
          automaticallyImplyDrawerHamburger: true,
          hint: 'What are you looking for?',
          openWidth: MediaQuery.of(context).size.width,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(102, 102, 102, 1),
          ),
          backgroundColor: Colors.white,
          openAxisAlignment: 0.0,
          axisAlignment: 0.0,
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            FloatingSearchBarAction(
              showIfOpened: false,
              child: CircularButton(
                icon: Icon(
                  Icons.notifications_rounded,
                  size: 24,
                  color: Colors.grey[800],
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Notify()));
                },
              ),
            ),
            FloatingSearchBarAction.searchToClear(
              showIfClosed: false,
            ),
          ],
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: Colors.accents.map((color) {
                    return Container(height: 112, color: color);
                  }).toList(),
                ),
              ),
            );
          },
          body: Stack(
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: SizedBox(
                    height: 35,
                    child: ListView(
                        physics: const BouncingScrollPhysics(),
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
                              setmarkers();
                            },
                            child: Container(
                              width: 70,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                isSelected[2] = true;
                              });
                              setmarkers();
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
                              setmarkers();
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
                              setmarkers();
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
                              setmarkers();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: !isSelected[1]
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              66, 103, 178, 1),
                                          // change width to 1.5
                                          width: 1.5),
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
                        ]),
                  ),
                ),
              ),
              (isSelected[0] | isSelected[1])
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Center(
                                      child: Text(
                                        "Apply Filter",
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ),
                                    content: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CheckboxListTile(
                                          dense: true,
                                          activeColor: Colors.orangeAccent,
                                          title: const Text(
                                            'Orphanages',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: check[0],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              check[0] = value!;
                                            });
                                          },
                                        ),
                                        CheckboxListTile(
                                          dense: true,
                                          activeColor: Colors.orangeAccent,
                                          title: const Text(
                                            'Old Age Homes',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: check[1],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              check[1] = value!;
                                            });
                                          },
                                        ),
                                        CheckboxListTile(
                                          dense: true,
                                          activeColor: Colors.orangeAccent,
                                          title: const Text(
                                            'NGO\'s',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: check[2],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              check[2] = value!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      OutlinedButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.varelaRound()
                                                    .fontFamily,
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
                                                GoogleFonts.varelaRound()
                                                    .fontFamily,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                  );
                                }),
                              );
                            },
                            child: const Icon(
                              Icons.tune_rounded,
                              size: 30,
                              color: Colors.black,
                            ),
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
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: _currentIcon
                          ? const Icon(
                              Icons.gps_not_fixed_rounded,
                              key: ValueKey('download'),
                            )
                          : const Icon(
                              Icons.gps_fixed_rounded,
                              key: ValueKey('done'),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "ITEM NAME",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  66, 103, 178, 1),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height: 100,
                                        child: const Center(
                                          child: Text("IMAGE 1"),
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              211, 211, 211, 1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: 100,
                                          child: const Center(
                                            child: Text("IMAGE 2"),
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                211, 211, 211, 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Chat")),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  : Container(),
            ],
          ),
        ),
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

    final GoogleMapController controller = await _controller.future;
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('Current-uid'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(
            title: "Current ",
          ),
          onTap: () {
            setState(() {
              _markerclicked = true;
            });
          },
        ),
      );
    });
  }

  getnearbylocations(String locationtype, LatLng current) async {}
}
