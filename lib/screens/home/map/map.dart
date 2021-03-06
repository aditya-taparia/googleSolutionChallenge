import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/chat/individualchat.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/request_form.dart';
import 'package:googlesolutionchallenge/screens/home/linkspace/forum.dart';
import 'package:googlesolutionchallenge/screens/utils/notification.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:googlesolutionchallenge/widgets/map_data_card.dart';
import 'package:googlesolutionchallenge/widgets/map_request_cards.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final NavigationBloc bloc;
  const MapScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late LocationPermission permission;
  List<bool> check = [true, true, true];
  double radius = 10.0;
  bool Maptoggle = true;
  Set<Polyline> _polylines = Set<Polyline>();
  int _polylineIdCounter = 1;
  var directions;

  late LatLng _current = const LatLng(15.5057, 80.0499);

  Set<Marker> _markers = {};
  bool _mapload = true;
  bool showgeolocationwidget = false;
  bool isLinkedspace = false;

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
  List<String> userListId = [];
  List<Map> userList2 = [];
  List<String> userListId2 = [];
  List userList3 = [];
  //map window
  double _height = 100;
  bool _open = false;
  bool _markerclicked = false;
  bool _gpsIcons = true;
  double twopointdistance = 0;

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
    await getLocation();
    setState(() {
      _gpsIcons = false;
    });

    // Calling posts which are open to work
    final Future<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Posts').where('accepted-by', isEqualTo: '').get();

    _usersStream.then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> val = element.data() as Map<String, dynamic>;
        LatLng temp = LatLng(double.parse(val['location'].latitude.toString()), double.parse(val['location'].longitude.toString()));
        twopointdistance = getraddist(temp, _current);
        if (twopointdistance <= radius) {
          userList.add(val);
          userListId.add(element.id);
        }
      });
    });

    final Future<QuerySnapshot> _users2Stream = FirebaseFirestore.instance.collection('Linkspace').get();

    _users2Stream.then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> val = element.data() as Map<String, dynamic>;
        LatLng temp = LatLng(double.parse(val['locality'].latitude.toString()), double.parse(val['locality'].longitude.toString()));
        twopointdistance = getraddist(temp, _current);
        if (twopointdistance <= radius) {
          userList2.add(val);
          userListId2.add(element.id);
        }
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
            destination = _current;
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
        List ll = await getLoc('Orphanages', _current.latitude, _current.longitude, 2000);
        setState(() {
          nearbymarkers1 = ll;
        });
      }
      if (check[1]) {
        List ll = await getLoc('Old+Age+Homes', _current.latitude, _current.longitude, 2000);
        setState(() {
          nearbymarkers2 = ll;
        });
      }
      if (check[2]) {
        List ll = await getLoc('NGO', _current.latitude, _current.longitude, 2000);
        setState(() {
          nearbymarkers3 = ll;
        });
      }
    }

    if (check[0]) {
      nearbymarkers1.forEach((element) {
        community1.add(LatLng(element["geometry"]["location"]["lat"], element["geometry"]["location"]["lng"]));
      });
    }
    if (check[1]) {
      nearbymarkers2.forEach((element) {
        community2.add(LatLng(element["geometry"]["location"]["lat"], element["geometry"]["location"]["lng"]));
      });
    }
    if (check[2]) {
      nearbymarkers3.forEach((element) {
        community3.add(LatLng(element["geometry"]["location"]["lat"], element["geometry"]["location"]["lng"]));
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
          if (element["category"].contains("item request")) {
            _markers.add(
              Marker(
                markerId: MarkerId('id-1' + element.toString()),
                position: LatLng(double.parse(element["location"].latitude.toString()), double.parse(element["location"].longitude.toString())),
                onTap: () {
                  setState(() {
                    isLinkedspace = false;
                    sendername = element["given-by-name"];
                    senderuid = element["given-by"];
                    destination =
                        LatLng(double.parse(element["location"].latitude.toString()), double.parse(element["location"].longitude.toString()));
                    _markerclicked = true;
                  });
                },
                infoWindow: InfoWindow(
                  title: element["given-by-name"],
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
          if (element["category"].contains("job request")) {
            _markers.add(
              Marker(
                markerId: MarkerId('id-1' + element.toString()),
                position: LatLng(double.parse(element["location"].latitude.toString()), double.parse(element["location"].longitude.toString())),
                onTap: () {
                  setState(() {
                    isLinkedspace = false;
                    sendername = element["given-by-name"];
                    senderuid = element["given-by"];
                    destination =
                        LatLng(double.parse(element["location"].latitude.toString()), double.parse(element["location"].longitude.toString()));
                    _markerclicked = true;
                  });
                },
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                infoWindow: InfoWindow(
                  title: element["given-by-name"],
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
              position: LatLng(double.parse(element["locality"].latitude.toString()), double.parse(element["locality"].longitude.toString())),
              onTap: () {
                setState(() {
                  isLinkedspace = true;
                  sendername = element["name"];
                  senderuid = element["ownerid"];
                  destination = LatLng(double.parse(element["locality"].latitude.toString()), double.parse(element["locality"].longitude.toString()));
                  _markerclicked = true;
                });
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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
    Set<Circle> circles = {
      Circle(
        fillColor: Colors.blue.withOpacity(0.15),
        strokeColor: Colors.transparent,
        circleId: const CircleId("circleid"),
        center: LatLng(_current.latitude, _current.longitude),
        radius: radius * 1000,
      )
    };

    // Map Circle
    double _localradius = 10;

    // CarouselController
    int _activeItem = 0;
    final CarouselController _carouselcontroller = CarouselController();

    // Search Contoller
    final searchcontroller = FloatingSearchBarController();
    List<String> _searchList = [
      'Surat',
      'Indore',
      'Kerala',
      'Andhra Pradesh',
    ];

    return Stack(
      children: [
        FloatingSearchBar(
          controller: searchcontroller,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Notify()));
                },
              ),
            ),
            FloatingSearchBarAction.searchToClear(
              showIfClosed: false,
            ),
          ],
          // TODO: Search Bar
          onQueryChanged: (value) {},
          onSubmitted: (value) {},
          progress: false,
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _searchList.map((place) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            searchcontroller.query = place;
                          },
                          leading: Icon(
                            Icons.history_rounded,
                            color: Colors.grey[600],
                          ),
                          title: Text(
                            place,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ],
                    );
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
                  circles: circles,
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
                                  if (isSelected[0] || (isSelected[3] && isSelected[4])) {
                                    return builditemjoblist(userList[index], context, userListId[index], widget.bloc);
                                  } else if (isSelected[3]) {
                                    if (userList[index]["category"].contains("item request")) {
                                      return builditemjoblist(userList[index], context, userListId[index], widget.bloc);
                                    }
                                  } else {
                                    if (userList[index]["category"].contains("job request")) {
                                      return builditemjoblist(userList[index], context, userListId[index], widget.bloc);
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
                child: StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: !_drive
                        ? SizedBox(
                            height: 35,
                            child: ListView(physics: const BouncingScrollPhysics(), scrollDirection: Axis.horizontal, shrinkWrap: true, children: [
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (!isFilled[0]) {
                                      isFilled[0] = true;
                                    }
                                    isSelected.asMap().forEach((index, value) {
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
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  decoration: !isFilled[0]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: const Color.fromRGBO(66, 103, 178, 1), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        )
                                      : selectedDecoration,
                                  child: Center(
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: !isFilled[0] ? const Color.fromRGBO(66, 103, 178, 1) : Colors.white,
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
                                          isSelected.asMap().forEach((index, value) {
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
                                              setState(() {
                                                isSelected.asMap().forEach((index, value) {
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
                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: !isFilled[2]
                                            ? BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: const Color.fromRGBO(66, 103, 178, 1), width: 1.5),
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                            : selectedDecoration,
                                        child: Center(
                                          child: Text(
                                            "LinkSpaces",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: !isFilled[2] ? const Color.fromRGBO(66, 103, 178, 1) : Colors.white,
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
                                    isSelected.asMap().forEach((index, value) {
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
                                        setState(() {
                                          isSelected.asMap().forEach((index, value) {
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
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  decoration: !isFilled[3]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: const Color.fromRGBO(66, 103, 178, 1), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        )
                                      : selectedDecoration,
                                  child: Center(
                                    child: Text(
                                      "Item Requests",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: !isFilled[3] ? const Color.fromRGBO(66, 103, 178, 1) : Colors.white,
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
                                    isSelected.asMap().forEach((index, value) {
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
                                        setState(() {
                                          isSelected.asMap().forEach((index, value) {
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
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  decoration: !isFilled[4]
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: const Color.fromRGBO(66, 103, 178, 1), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        )
                                      : selectedDecoration,
                                  child: Center(
                                    child: Text(
                                      "Job Requests",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: !isFilled[4] ? const Color.fromRGBO(66, 103, 178, 1) : Colors.white,
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
                                          isSelected.asMap().forEach((index, value) {
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
                                              setState(() {
                                                isSelected.asMap().forEach((index, value) {
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
                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: !isFilled[1]
                                            ? BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: const Color.fromRGBO(66, 103, 178, 1), width: 1.5),
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                            : selectedDecoration,
                                        child: Center(
                                          child: Text(
                                            "Community Service",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: !isFilled[1] ? const Color.fromRGBO(66, 103, 178, 1) : Colors.white,
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
                                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                                        child: Text(
                                          remdist + " (" + remtime + ")",
                                          style: const TextStyle(color: Color.fromRGBO(66, 103, 178, 1), fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      collapsed: Container(),
                                      expanded: Text("Destination : " + endadd),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: OutlinedButton(onPressed: () {}, child: const Text("Next Direction")),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4,
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
                  );
                }),
              ),
              (isSelected[1])
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 156, 0, 0),
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Center(
                                      child: Text(
                                        "Apply Filter",
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ),
                                    content: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CheckboxListTile(
                                          dense: true,
                                          activeColor: Colors.orangeAccent,
                                          title: const Text(
                                            'Orphanages',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          controlAffinity: ListTileControlAffinity.leading,
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
                                          controlAffinity: ListTileControlAffinity.leading,
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
                                          controlAffinity: ListTileControlAffinity.leading,
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
                                            fontFamily: GoogleFonts.varelaRound().fontFamily,
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
                                            fontFamily: GoogleFonts.varelaRound().fontFamily,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setmarkers();
                                        },
                                      ),
                                    ],
                                    actionsAlignment: MainAxisAlignment.spaceAround,
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
                      ),
                    )
                  : Container(),

              // Map Radius Button
              /* Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: const Center(
                              child: Text(
                                "Select Radius",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            content: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Radius : ' + _localradius.toString() + ' km'),
                                Slider(
                                  value: _localradius,
                                  onChanged: (value) {
                                    setState(() {
                                      _localradius = value;
                                    });
                                  },
                                  min: 10,
                                  max: 50,
                                  divisions: 40,
                                  label: '${_localradius.round()} km',
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              OutlinedButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.varelaRound().fontFamily,
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
                                    fontFamily: GoogleFonts.varelaRound().fontFamily,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    radius = _localradius;                                    
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                            actionsAlignment: MainAxisAlignment.spaceAround,
                          );
                        }),
                      );
                    },
                    child: const Icon(
                      Icons.filter_tilt_shift_rounded,
                      size: 30,
                    ),
                  ),
                ),
              ), */

              // Map List Button
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
                      child: Maptoggle
                          ? const Icon(
                              Icons.subject_rounded,
                              size: 30,
                              key: ValueKey('list'),
                            )
                          : const Icon(
                              Icons.map_rounded,
                              size: 30,
                              key: ValueKey('map'),
                            ),
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
                      _gpsIcons ? getLocation() : null;
                      setState(() {
                        _gpsIcons = !_gpsIcons;
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
                      child: _gpsIcons
                          ? const Icon(
                              Icons.gps_not_fixed_rounded,
                              key: ValueKey('no_gps'),
                            )
                          : const Icon(
                              Icons.gps_fixed_rounded,
                              key: ValueKey('gps'),
                            ),
                    ),
                  ),
                ),
              ),
              _markerclicked
                  ? (destination == _current)
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              int sensitivity = 8;
                              if (details.delta.dy > sensitivity) {
                                setState(() {
                                  _height = 100;
                                });
                              } else if (details.delta.dy < -sensitivity) {
                                setState(() {
                                  _height = 250;
                                });
                              }
                            },
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
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onVerticalDragUpdate: (details) {
                                          int sensitivity = 8;
                                          if (details.delta.dy > sensitivity) {
                                            setState(() {
                                              _height = 100;
                                            });
                                          } else if (details.delta.dy < -sensitivity) {
                                            setState(() {
                                              _height = 250;
                                            });
                                          }
                                        },
                                        child: SizedBox(
                                            width: MediaQuery.of(context).size.width - 16.0,
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              const Center(
                                                child: Icon(Icons.drag_handle_rounded, size: 30),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Center(
                                                child: Text(
                                                  ' Add Item or Job Request',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Color.fromRGBO(66, 103, 178, 1),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  DottedBorder(
                                                    borderType: BorderType.RRect,
                                                    strokeWidth: 2,
                                                    radius: const Radius.circular(10),
                                                    color: Colors.grey,
                                                    dashPattern: const [5, 5],
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const RequestForm(
                                                              postType: 'Item Request',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: SizedBox(
                                                        width: 160,
                                                        height: 100,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: const [
                                                              Icon(
                                                                Icons.add,
                                                                size: 30,
                                                                color: Color.fromRGBO(66, 103, 178, 1),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                'Add Item Request',
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color.fromRGBO(66, 103, 178, 1),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DottedBorder(
                                                    borderType: BorderType.RRect,
                                                    strokeWidth: 2,
                                                    radius: const Radius.circular(10),
                                                    color: Colors.grey,
                                                    dashPattern: const [5, 5],
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const RequestForm(
                                                              postType: 'Job Request',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: SizedBox(
                                                        height: 100,
                                                        width: 160,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: const [
                                                              Icon(
                                                                Icons.add,
                                                                size: 30,
                                                                color: Color.fromRGBO(66, 103, 178, 1),
                                                              ),
                                                              SizedBox(height: 10),
                                                              Center(
                                                                child: Text(
                                                                  'Add Job Request',
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Color.fromRGBO(66, 103, 178, 1),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]))),
                                  ),
                                )),
                          ),
                        )
                      : StreamBuilder<QuerySnapshot>(
                          stream: isLinkedspace
                              ? FirebaseFirestore.instance
                                  .collection('Linkspace')
                                  .where('locality', isEqualTo: GeoPoint(destination.latitude, destination.longitude))
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('Posts')
                                  .where('location', isEqualTo: GeoPoint(destination.latitude, destination.longitude))
                                  .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }
                            if (!snapshot.hasData) {
                              return Container(); // change to vector image
                            }
                            if (snapshot.connectionState == ConnectionState.active) {
                              var snap = snapshot.data!.docs;

                              return StatefulBuilder(builder: (context, setState) {
                                return Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onVerticalDragUpdate: (details) {
                                      int sensitivity = 8;
                                      if (details.delta.dy > sensitivity) {
                                        setState(() {
                                          _height = 100;
                                        });
                                      } else if (details.delta.dy < -sensitivity) {
                                        setState(() {
                                          _height = 300;
                                        });
                                      }
                                    },
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
                                        padding: const EdgeInsets.all(4.0),
                                        child: SingleChildScrollView(
                                          physics: const NeverScrollableScrollPhysics(),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Center(
                                                child: Icon(
                                                  Icons.drag_handle_rounded,
                                                  size: 30,
                                                ),
                                              ),
                                              snap.length == 1
                                                  ? isLinkedspace
                                                      ? MapDataCard(
                                                          title: '${snap[0]['name']} LinkSpace',
                                                          actions: GestureDetector(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 8.0),
                                                              child: favselect ? fav : fav2,
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                favselect = !favselect;
                                                              });
                                                            },
                                                          ),
                                                          description: snap[0]['description'].toString(),
                                                          moreInfo:
                                                              snap[0]['member'].length == 1 ? '1 member' : '${snap[0]['member'].length} members',
                                                          moreActions: [
                                                            snap[0]['member'].contains(user!.userid.toString())
                                                                ? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                                        child: OutlinedButton.icon(
                                                                          onPressed: () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Forum(
                                                                                          id: snap[0].id,
                                                                                          name: snap[0]['name'],
                                                                                        )));
                                                                          },
                                                                          icon: const Icon(Icons.groups_rounded),
                                                                          label: const Text('Open Space'),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                                        child: ElevatedButton.icon(
                                                                          onPressed: () async {
                                                                            setState(() {
                                                                              _markerclicked = false;
                                                                              _drive = true;
                                                                              _polylines = {};
                                                                            });
                                                                            var temp = await getDirections(_current, destination);
                                                                            _setPolyline(directions);
                                                                          },
                                                                          icon: const Icon(Icons.directions_car_filled_rounded),
                                                                          label: const Text('Drive'),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox(
                                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                                    child: ElevatedButton.icon(
                                                                      // TODO: Join Space
                                                                      onPressed: () {},
                                                                      icon: const Icon(Icons.groups_rounded),
                                                                      label: const Text('Join Space'),
                                                                    ),
                                                                  ),
                                                          ],
                                                        )
                                                      : MapDataCard(
                                                          title: '${snap[0]['title']}',
                                                          actions: GestureDetector(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 8.0),
                                                              child: favselect ? fav : fav2,
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                favselect = !favselect;
                                                              });
                                                            },
                                                          ),
                                                          description: snap[0]['description'].toString(),
                                                          chip: snap[0]['post-type'].toString(),
                                                          moreActions: [
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.4,
                                                              child: snap[0]['waiting-list'].contains(user!.userid)
                                                                  ? OutlinedButton.icon(
                                                                      style: OutlinedButton.styleFrom(
                                                                        primary: const Color.fromRGBO(66, 103, 178, 1),
                                                                        onSurface: Colors.grey,
                                                                      ),
                                                                      onPressed: snap[0]['chat-id'] == ""
                                                                          ? null
                                                                          : () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) {
                                                                                  return IndividualChat(
                                                                                    id: snap[0]['chat-id'],
                                                                                  );
                                                                                }),
                                                                              );
                                                                            },
                                                                      icon: const Icon(Icons.forum_rounded),
                                                                      label: const Text('Chat'),
                                                                    )
                                                                  : OutlinedButton.icon(
                                                                      onPressed: () async {
                                                                        FirebaseFirestore.instance.collection('Posts').doc(snap[0].id).update({
                                                                          'waiting-list': FieldValue.arrayUnion([user.userid.toString()])
                                                                        }).then((value) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(
                                                                              content: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.check_rounded,
                                                                                    color: Colors.green[800],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(
                                                                                    'Request Sent to the owner',
                                                                                    style: TextStyle(
                                                                                      color: Colors.green[800],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              duration: const Duration(seconds: 2),
                                                                              backgroundColor: Colors.green[50],
                                                                              behavior: SnackBarBehavior.floating,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              elevation: 3,
                                                                            ),
                                                                          );
                                                                          widget.bloc.changeNavigationIndex(Navigation.dashboard);
                                                                        });
                                                                      },
                                                                      icon: const Icon(Icons.check_rounded),
                                                                      label: const Text('Accept'),
                                                                    ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.4,
                                                              child: ElevatedButton.icon(
                                                                onPressed: () async {
                                                                  setState(() {
                                                                    _markerclicked = false;
                                                                    _drive = true;
                                                                    _polylines = {};
                                                                  });
                                                                  var temp = await getDirections(_current, destination);
                                                                  _setPolyline(directions);
                                                                },
                                                                icon: const Icon(Icons.directions_car_filled_rounded),
                                                                label: const Text('Drive'),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                  : CarouselSlider.builder(
                                                      carouselController: _carouselcontroller,
                                                      itemCount: snap.length,
                                                      itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                                                        if (isLinkedspace) {
                                                          return MapDataCard(
                                                            elevation: 1.5,
                                                            title: '${snap[index]['name']} LinkSpace',
                                                            actions: GestureDetector(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                child: favselect ? fav : fav2,
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  favselect = !favselect;
                                                                });
                                                              },
                                                            ),
                                                            description: snap[index]['description'].toString(),
                                                            moreInfo: snap[index]['member'].length == 1
                                                                ? '1 member'
                                                                : '${snap[0]['member'].length} members',
                                                            moreActions: [
                                                              snap[index]['member'].contains(user!.userid.toString())
                                                                  ? Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: MediaQuery.of(context).size.width * 0.45,
                                                                          child: OutlinedButton.icon(
                                                                            onPressed: () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => Forum(
                                                                                            id: snap[0].id,
                                                                                            name: snap[0]['name'],
                                                                                          )));
                                                                            },
                                                                            icon: const Icon(Icons.groups_rounded),
                                                                            label: const Text('Open Space'),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        SizedBox(
                                                                          width: MediaQuery.of(context).size.width * 0.3,
                                                                          child: ElevatedButton.icon(
                                                                            onPressed: () async {
                                                                              setState(() {
                                                                                _markerclicked = false;
                                                                                _drive = true;
                                                                                _polylines = {};
                                                                              });
                                                                              var temp = await getDirections(_current, destination);
                                                                              _setPolyline(directions);
                                                                            },
                                                                            icon: const Icon(Icons.directions_car_filled_rounded),
                                                                            label: const Text('Drive'),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                                      child: ElevatedButton.icon(
                                                                        // TODO: Join Space
                                                                        onPressed: () {},
                                                                        icon: const Icon(Icons.groups_rounded),
                                                                        label: const Text('Join Space'),
                                                                      ),
                                                                    ),
                                                            ],
                                                          );
                                                        } else {
                                                          return MapDataCard(
                                                            elevation: 1.5,
                                                            title: '${snap[index]['title']}',
                                                            actions: GestureDetector(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                child: favselect ? fav : fav2,
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  favselect = !favselect;
                                                                });
                                                              },
                                                            ),
                                                            description: snap[index]['description'].toString(),
                                                            chip: snap[index]['post-type'].toString(),
                                                            moreActions: [
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.4,
                                                                child: snap[0]['waiting-list'].contains(user!.userid)
                                                                    ? OutlinedButton.icon(
                                                                        style: OutlinedButton.styleFrom(
                                                                          primary: const Color.fromRGBO(66, 103, 178, 1),
                                                                          onSurface: Colors.grey,
                                                                        ),
                                                                        onPressed: snap[0]['chat-id'] == ""
                                                                            ? null
                                                                            : () {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) {
                                                                                    return IndividualChat(
                                                                                      id: snap[0]['chat-id'],
                                                                                    );
                                                                                  }),
                                                                                );
                                                                              },
                                                                        icon: const Icon(Icons.forum_rounded),
                                                                        label: const Text('Chat'),
                                                                      )
                                                                    : OutlinedButton.icon(
                                                                        onPressed: () async {
                                                                          FirebaseFirestore.instance.collection('Posts').doc(snap[0].id).update({
                                                                            'waiting-list': FieldValue.arrayUnion([user.userid.toString()])
                                                                          }).then((value) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.check_rounded,
                                                                                      color: Colors.green[800],
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Text(
                                                                                      'Request Sent to the owner',
                                                                                      style: TextStyle(
                                                                                        color: Colors.green[800],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                duration: const Duration(seconds: 2),
                                                                                backgroundColor: Colors.green[50],
                                                                                behavior: SnackBarBehavior.floating,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                elevation: 3,
                                                                              ),
                                                                            );
                                                                            widget.bloc.changeNavigationIndex(Navigation.dashboard);
                                                                          });
                                                                        },
                                                                        icon: const Icon(Icons.check_rounded),
                                                                        label: const Text('Accept'),
                                                                      ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.4,
                                                                child: ElevatedButton.icon(
                                                                  onPressed: () async {
                                                                    setState(() {
                                                                      _markerclicked = false;
                                                                      _drive = true;
                                                                      _polylines = {};
                                                                    });
                                                                    var temp = await getDirections(_current, destination);
                                                                    _setPolyline(directions);
                                                                  },
                                                                  icon: const Icon(Icons.directions_car_filled_rounded),
                                                                  label: const Text('Drive'),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                      options: CarouselOptions(
                                                        autoPlay: false,
                                                        enlargeCenterPage: true,
                                                        viewportFraction: 1.0,
                                                        initialPage: 0,
                                                        enableInfiniteScroll: false,
                                                        onPageChanged: (index, reason) {
                                                          setState(() {
                                                            _activeItem = index;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                              snap.length == 1
                                                  ? Container()
                                                  : Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: snap.asMap().entries.map((entry) {
                                                        return GestureDetector(
                                                          onTap: () => _carouselcontroller.animateToPage(entry.key),
                                                          child: Container(
                                                            width: 12.0,
                                                            height: 12.0,
                                                            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: _activeItem == entry.key ? const Color.fromRGBO(66, 103, 178, 1) : Colors.grey,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }
                            return Container();
                          })
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    final GoogleMapController controller = await _controller.future;
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 11));

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
    setmarkers();
  }

// PLACES API
  getLoc(String query, double lat, double lng, double radius) async {
    final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=' +
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
    String originstring = origin.toString().replaceAll("LatLng(", "").replaceAll(")", "");
    String destinationstring = destination.toString().replaceAll("LatLng(", "").replaceAll(")", "");

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
      'polyline_decode': PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    final GoogleMapController controller2 = await _controller.future;

    Map<String, dynamic> boundsNe = result['bounds_ne'];
    Map<String, dynamic> boundsSw = result['bounds_se'];

    controller2.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(boundsSw['lat'], boundsSw['lng']), northeast: LatLng(boundsNe['lat'], boundsNe['lng'])), 50));

    setState(() {
      remdist = result['distance'];
      remtime = result['duration'];
      endadd = result['end_address'];
      directions = result['polyline_decode'];
    });
  }
}

double getraddist(LatLng element, LatLng current) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((current.latitude - element.latitude) * p) / 2 +
      c(element.latitude * p) * c(current.latitude * p) * (1 - c((current.longitude - element.longitude) * p)) / 2;
  return 12742 * 1.609344 * asin(sqrt(a));
}

createchat(String currUserId, String othUserId, String name1) async {
  int y = 0;
  final DocumentSnapshot<Map<String, dynamic>> _username = await FirebaseFirestore.instance.collection('Userdata').doc(currUserId).get();

  String name2 = _username.data()!["name"];
  Map othuserdata = {"name": name1, "id": othUserId, "imgUrl": ""};
  Map currUserData = {"name": name2, "id": currUserId, "imgUrl": ""};
  CollectionReference chatCollection = await FirebaseFirestore.instance.collection('chats');
  var x = chatCollection.where('users', isEqualTo: [othUserId, currUserId]).get();
  x.then((value) {
    y = value.docs.length;
    if (y == 0) {
      var x = chatCollection.where('users', isEqualTo: [currUserId, othUserId]).get();
      x.then((value) async {
        y = value.docs.length;
        if (y == 0) {
          final addchat = FirebaseFirestore.instance.collection("chats").doc();
          final json = {
            'chatdata': {},
            'users': [currUserId, othUserId],
            'name': [currUserData, othuserdata],
            'read': [0, 0]
          };
          await addchat.set(json);
        }
      });
    }
  });
}

Widget builditemjoblist(Map userList, BuildContext context, String currUserId, NavigationBloc bloc) {
  return MapRequestCard(
    bloc: bloc,
    title: userList['title'],
    description: userList['description'],
    postType: userList['post-type'].toString().toTitleCase(),
    postId: currUserId,
    givenBy: userList['given-by-name'],
    promisedAmount: userList['promised-amount'].toDouble(),
    waitingList: List<String>.from(userList['waiting-list']),
    chatId: userList['chat-id'],
  );
}
