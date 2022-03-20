import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/chat/sample.dart';
import 'package:googlesolutionchallenge/screens/utils/notification.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late LocationPermission permission;
  List<bool> check = [true, true, true];

  bool Maptoggle = true;
  Set<Polyline> _polylines = Set<Polyline>();
  int _polylineIdCounter = 1;
  var directions;

  late LatLng _current = const LatLng(15.5057, 80.0499);
  Set<Marker> _markers = {};
  bool _mapload = true;
  bool showgeolocationwidget = false;

// drive
  late LatLng destination = const LatLng(15.5057, 80.0499);
  bool _drive = false;
  String remdist = "";
  String remtime = "";
  String endadd = "";

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
  List<bool> isSelected = [true, false, true, true, true];
  List<bool> isFilled = [true, false, false, false, false];

  List<LatLng> ll = [];
  List<Map> userList = [];
  List<Map> userList2 = [];
  List userList3 = [];
  //map window
  double _height = 100;
  bool _open = false;
  bool _markerclicked = false;
  bool _currentIcon = true;

  Set<LatLng> community = {};
  Set<LatLng> community1 = {};
  Set<LatLng> community2 = {};
  Set<LatLng> community3 = {};
  late List nearbymarkers1 = [];
  late List nearbymarkers2 = [];
  late List nearbymarkers3 = [];

  //getting data for chat
  String sendername = "";
  String senderuid = "";

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 5,
      color: Colors.blue,
      points: points
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));
  }

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

  void setmarkers() async {
    _markers = {};

//Current location marker

    _markers.add(
      Marker(
        markerId: MarkerId('id-geolocation'),
        position: _current,
        onTap: () {
          setState(() {
            _markerclicked = true;
          });
        },
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: 'User Name',
          snippet: '-_-',
        ),
      ),
    );

    if (isSelected[1]) {
      if (check[0]) {
        List ll = await getLoc(
            'Orphanages', _current.latitude, _current.longitude, 2000);
        setState(() {
          nearbymarkers1 = ll;
        });
      }
      if (check[1]) {
        List ll = await getLoc(
            'Old+Age+Homes', _current.latitude, _current.longitude, 2000);
        setState(() {
          nearbymarkers2 = ll;
        });
      }
      if (check[2]) {
        List ll =
            await getLoc('NGO', _current.latitude, _current.longitude, 2000);
        setState(() {
          nearbymarkers3 = ll;
        });
      }
    }

    if (check[0]) {
      nearbymarkers1.forEach((element) {
        community1.add(LatLng(element["geometry"]["location"]["lat"],
            element["geometry"]["location"]["lng"]));
      });
    }
    if (check[1]) {
      nearbymarkers2.forEach((element) {
        community2.add(LatLng(element["geometry"]["location"]["lat"],
            element["geometry"]["location"]["lng"]));
      });
    }
    if (check[2]) {
      nearbymarkers3.forEach((element) {
        community3.add(LatLng(element["geometry"]["location"]["lat"],
            element["geometry"]["location"]["lng"]));
      });
    }

    setState(() {
      community = {};
      check[0] ? community = community.union(community1) : null;
      check[1] ? community = community.union(community2) : null;
      check[2] ? community = community.union(community3) : null;

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
                    sendername = element["name"];
                    senderuid = element["owner_id"];
                    destination = LatLng(
                        double.parse(element["location"].latitude.toString()),
                        double.parse(element["location"].longitude.toString()));
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
                    sendername = element["name"];
                    senderuid = element["owner_id"];
                    destination = LatLng(
                        double.parse(element["location"].latitude.toString()),
                        double.parse(element["location"].longitude.toString()));
                    _markerclicked = true;
                  });
                },
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange),
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
                  sendername = element["name"];
                  senderuid = element["ownerid"];
                  destination = LatLng(
                      double.parse(element["locality"].latitude.toString()),
                      double.parse(element["locality"].longitude.toString()));
                  _markerclicked = true;
                });
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              infoWindow: InfoWindow(
                title: 'LinkSpace',
                snippet: element['location'],
              ),
            ),
          );
        });
      }

//community service markers
      if (isSelected[1]) {
        community.forEach((element) {
          _markers.add(
            Marker(
              markerId: MarkerId('id-1' + element.toString()),
              position: element,
              onTap: () {
                setState(() {
                  destination = element;
                  _markerclicked = true;
                });
              },
            ),
          );
        });
      }
    });
  }

  void _onMapCreated(controller) {
    _markers = {};
    community = {};
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
    final user = Provider.of<Users?>(context);
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
                    zoom: 6,
                  ),
                  onMapCreated: _onMapCreated,
                  onTap: (LatLng latLng) {
                    setState(() {
                      _markerclicked = false;
                    });
                  },
                  markers: _markers,
                  polylines: _polylines,
                ),
              ),
              !Maptoggle
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white.withOpacity(0.5),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Container(
                            child: ListView.builder(
                                itemCount: userList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (isSelected[0] ||
                                      (isSelected[3] && isSelected[4])) {
                                    return Builditemjoblist(
                                        userList[index], context);
                                  } else if (isSelected[3]) {
                                    if (userList[index]["category"]
                                        .contains("item")) {
                                      return Builditemjoblist(
                                          userList[index], context);
                                    }
                                  } else {
                                    if (userList[index]["category"]
                                        .contains("request")) {
                                      return Builditemjoblist(
                                          userList[index], context);
                                    }
                                  }
                                  return Container();
                                }),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: !_drive
                      ? SizedBox(
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
                                      if (!isFilled[0]) {
                                        isFilled[0] = true;
                                      }
                                      isSelected
                                          .asMap()
                                          .forEach((index, value) {
                                        if (value == false) {
                                          isSelected[index] = true;
                                        }
                                        isSelected[1] = false;
                                      });
                                      isFilled.asMap().forEach((index, value) {
                                        if (value == true && index != 0) {
                                          isFilled[index] = false;
                                        }
                                      });
                                    });
                                    setmarkers();
                                  },
                                  child: Container(
                                    width: 70,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: !isFilled[0]
                                        ? BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    66, 103, 178, 1),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )
                                        : selectedDecoration,
                                    child: Center(
                                      child: Text(
                                        "All",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: !isFilled[0]
                                              ? const Color.fromRGBO(
                                                  66, 103, 178, 1)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Maptoggle
                                    ? GestureDetector(
                                        onTap: () {
                                          int count = 0;
                                          setState(() {
                                            print(isSelected[2]);
                                            isFilled[2] = !isFilled[2];

                                            if (isFilled[0]) {
                                              isFilled[0] = false;
                                            }
                                            if (!isFilled[2]) {
                                              isSelected[2] = !isSelected[2];
                                            }
                                            isSelected
                                                .asMap()
                                                .forEach((index, value) {
                                              if (isFilled[index] == false) {
                                                isSelected[index] = false;
                                              } else {
                                                isSelected[index] = true;
                                              }
                                            });

                                            if (isSelected[2]) {
                                              isSelected[0] = false;
                                              isFilled[0] = false;
                                            }
                                            if (!isFilled[2]) {
                                              for (int i = 0; i < 5; i++) {
                                                if (!isFilled[i]) {
                                                  count++;
                                                }
                                              }
                                              if (count == 5) {
                                                print('object');
                                                setState(() {
                                                  isSelected
                                                      .asMap()
                                                      .forEach((index, value) {
                                                    isSelected[index] = true;
                                                  });
                                                  isFilled[0] = true;
                                                  isSelected[1] = false;
                                                });
                                              }
                                            }
                                          });
                                          setmarkers();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: !isFilled[2]
                                              ? BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              66, 103, 178, 1),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                )
                                              : selectedDecoration,
                                          child: Center(
                                            child: Text(
                                              "LinkSpaces",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: !isFilled[2]
                                                    ? const Color.fromRGBO(
                                                        66, 103, 178, 1)
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    int count = 0;
                                    setState(() {
                                      print(isSelected[3]);
                                      isFilled[3] = !isFilled[3];
                                      if (isFilled[0]) {
                                        isFilled[0] = false;
                                      }
                                      if (!isFilled[3]) {
                                        isSelected[3] = !isSelected[3];
                                      }
                                      isSelected
                                          .asMap()
                                          .forEach((index, value) {
                                        if (isFilled[index] == false) {
                                          isSelected[index] = false;
                                        } else {
                                          isSelected[index] = true;
                                        }
                                      });

                                      if (isSelected[3]) {
                                        isSelected[0] = false;
                                        isFilled[0] = false;
                                      }
                                      if (!isFilled[3]) {
                                        for (int i = 0; i < 5; i++) {
                                          if (!isFilled[i]) {
                                            count++;
                                          }
                                        }
                                        if (count == 5) {
                                          print('object');
                                          setState(() {
                                            isSelected
                                                .asMap()
                                                .forEach((index, value) {
                                              isSelected[index] = true;
                                            });
                                            isFilled[0] = true;

                                            isSelected[1] = false;
                                          });
                                        }
                                      }
                                    });
                                    setmarkers();
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: !isFilled[3]
                                        ? BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    66, 103, 178, 1),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )
                                        : selectedDecoration,
                                    child: Center(
                                      child: Text(
                                        "Item Requests",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: !isFilled[3]
                                              ? const Color.fromRGBO(
                                                  66, 103, 178, 1)
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
                                    int count = 0;
                                    setState(() {
                                      print(isSelected[4]);
                                      isFilled[4] = !isFilled[4];
                                      if (isFilled[0]) {
                                        isFilled[0] = false;
                                      }
                                      if (!isFilled[4]) {
                                        isSelected[4] = !isSelected[4];
                                      }
                                      isSelected
                                          .asMap()
                                          .forEach((index, value) {
                                        if (isFilled[index] == false) {
                                          isSelected[index] = false;
                                        } else {
                                          isSelected[index] = true;
                                        }
                                      });

                                      if (isSelected[4]) {
                                        isSelected[0] = false;
                                        isFilled[0] = false;
                                      }
                                      if (!isFilled[4]) {
                                        for (int i = 0; i < 5; i++) {
                                          if (!isFilled[i]) {
                                            count++;
                                          }
                                        }
                                        if (count == 5) {
                                          print('object');
                                          setState(() {
                                            isSelected
                                                .asMap()
                                                .forEach((index, value) {
                                              isSelected[index] = true;
                                            });
                                            isFilled[0] = true;

                                            isSelected[1] = false;
                                          });
                                        }
                                      }
                                    });
                                    setmarkers();
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: !isFilled[4]
                                        ? BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    66, 103, 178, 1),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )
                                        : selectedDecoration,
                                    child: Center(
                                      child: Text(
                                        "Job Requests",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: !isFilled[4]
                                              ? const Color.fromRGBO(
                                                  66, 103, 178, 1)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Maptoggle
                                    ? GestureDetector(
                                        onTap: () {
                                          int count = 0;
                                          setState(() {
                                            print(isSelected[1]);
                                            isFilled[1] = !isFilled[1];
                                            if (isFilled[0]) {
                                              isFilled[0] = false;
                                            }
                                            if (!isFilled[1]) {
                                              isSelected[1] = !isSelected[1];
                                            }
                                            isSelected
                                                .asMap()
                                                .forEach((index, value) {
                                              if (isFilled[index] == false) {
                                                isSelected[index] = false;
                                              } else {
                                                isSelected[index] = true;
                                              }
                                            });

                                            if (isSelected[1]) {
                                              isSelected[0] = false;
                                              isFilled[0] = false;
                                            }
                                            if (!isFilled[1]) {
                                              for (int i = 0; i < 5; i++) {
                                                if (!isFilled[i]) {
                                                  count++;
                                                }
                                              }
                                              if (count == 5) {
                                                print('object');
                                                setState(() {
                                                  isSelected
                                                      .asMap()
                                                      .forEach((index, value) {
                                                    isSelected[index] = true;
                                                  });
                                                  isFilled[0] = true;

                                                  isSelected[1] = false;
                                                });
                                              }
                                            }
                                          });
                                          setmarkers();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: !isFilled[1]
                                              ? BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              66, 103, 178, 1),
                                                      // change width to 1.5
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                )
                                              : selectedDecoration,
                                          child: Center(
                                            child: Text(
                                              "Community Service",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: !isFilled[1]
                                                    ? const Color.fromRGBO(
                                                        66, 103, 178, 1)
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ]),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ExpandablePanel(
                                    header: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 10),
                                      child: Text(
                                        remdist + " (" + remtime + ")",
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(66, 103, 178, 1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    collapsed: Container(),
                                    expanded: Text("Destination : " + endadd),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: OutlinedButton(
                                              onPressed: () {},
                                              child:
                                                  const Text("Next Direction")),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _drive = !_drive;
                                                  _polylines = {};
                                                });
                                              },
                                              child: Text("Cancel Drive")),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ), // ondrive widget
                ),
              ),
              (isSelected[1])
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
                                          setmarkers();
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
                    onPressed: () {
                      setState(() {
                        Maptoggle = !Maptoggle;
                      });
                    },
                    child: Maptoggle
                        ? const Icon(
                            Icons.add_location_rounded,
                            size: 30,
                          )
                        : const Icon(
                            Icons.map_rounded,
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
                                  Container(
                                    height: 110,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              createchat(
                                                  user!.userid.toString(),
                                                  senderuid,
                                                  sendername);
                                            },
                                            child: const Text("Chat")),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                _markerclicked = false;
                                                _drive = true;
                                                _polylines = {};
                                              });
                                              var temp = await getDirections(
                                                  _current, destination);
                                              _setPolyline(directions);
                                            },
                                            child: const Text("Drive"))
                                      ],
                                    ),
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
      _current = LatLng(position.latitude, position.longitude);
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

// PLACES API
  getLoc(String query, double lat, double lng, double radius) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=' +
            query +
            '&location=' +
            lat.toString() +
            ',' +
            lng.toString() +
            '&radius=' +
            radius.toString() +
            '&key=AIzaSyBnUiYa_7RlPXxh5szOCfxyj2l9Wlb7HU4'));
    final jsonStudent = await jsonDecode(response.body);
    print(query + jsonStudent["results"].length.toString());
    return jsonStudent["results"];
  }

//DIRECTIONS API
  getDirections(LatLng origin, LatLng destination) async {
    String originstring =
        origin.toString().replaceAll("LatLng(", "").replaceAll(")", "");
    String destinationstring =
        destination.toString().replaceAll("LatLng(", "").replaceAll(")", "");

    //print(originstring);
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$originstring&destination=$destinationstring&&key=AIzaSyBnUiYa_7RlPXxh5szOCfxyj2l9Wlb7HU4';

    final response = await http.get(Uri.parse(url));
    final json = await jsonDecode(response.body);
    //print(json);
    var result = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_se': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'distance': json['routes'][0]['legs'][0]['distance']['text'],
      'duration': json['routes'][0]['legs'][0]['duration']['text'],
      'end_address': json['routes'][0]['legs'][0]['end_address'],
      'polyline_decode': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    setState(() {
      remdist = result['distance'];
      remtime = result['duration'];
      endadd = result['end_address'];
      directions = result['polyline_decode'];
    });
  }
}

createchat(String currUserId, String othUserId, String name1) async {
  String y = "";
  final DocumentSnapshot<Map<String, dynamic>> _username =
      await FirebaseFirestore.instance
          .collection('Userdata')
          .doc(currUserId)
          .get();

  String name2 = _username.data()!["name"];
  Map othuserdata = {"name": name1, "id": othUserId, "imgUrl": ""};
  Map currUserData = {"name": name2, "id": currUserId, "imgUrl": ""};
  CollectionReference chatCollection =
      await FirebaseFirestore.instance.collection('chats');
  var x =
      chatCollection.where('users', isEqualTo: [othUserId, currUserId]).get();
  x.then((value) => y = value.toString());

  if (y.isEmpty) {
    var x =
        chatCollection.where('users', isEqualTo: [currUserId, othUserId]).get();
    x.then((value) => y = value.toString());
    print(currUserId + " " + othUserId);
  }
  if (y.isEmpty) {
    final addchat = FirebaseFirestore.instance.collection("chats").doc();
    final json = {
      'chatdata': {},
      'users': [currUserId, othUserId],
      'name': [currUserData, othuserdata]
    };
    await addchat.set(json);
  } else {
    //navigate to chatclflugakfd.
  }
}

Widget Builditemjoblist(Map userList, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(232, 236, 241, 1),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(""),
                    Text("IMG"),
                    Text("[" +
                        userList["location"].latitude.toString() +
                        " " +
                        userList["location"].longitude.toString() +
                        "]"),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromRGBO(66, 103, 178, 1),
                        width: 2.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Text(
                      userList["category"]
                          .toString()
                          .replaceAll("[", "")
                          .replaceAll("]", "")
                          .replaceAll(",", " | "),
                      style: const TextStyle(
                          color: Color.fromRGBO(66, 103, 178, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Text(userList["name"].toString()),
              Container(
                height: 50,
                width: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList["Provide"].length,
                    itemBuilder: (context, yindex) {
                      return userList["Provide_done"][yindex] == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(userList["Provide"][yindex].toString()),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    userList["Provide_des"][yindex].toString()),
                              ],
                            )
                          : Container();
                    }),
              )
            ],
          )
        ],
      ),
    ),
  );
}
