import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CommunityService extends StatefulWidget {
  const CommunityService({Key? key}) : super(key: key);

  @override
  State<CommunityService> createState() => _CommunityServiceState();
}

class _CommunityServiceState extends State<CommunityService> {
  int type = 1;
  late LocationPermission permission;
  bool belongtolinkspace = false;
  late LatLng current;
//  late LatLng _current = const LatLng(15.5057, 80.0499);
  Set<Map> community = {};
  Set<Map> community1 = {};
  Set<Map> community2 = {};
  Set<Map> community3 = {};
  late List nearbymarkers1 = [];
  late List nearbymarkers2 = [];
  late List nearbymarkers3 = [];

  void setmarkers() async {
    if (type == 1) {
      List ll =
          await getLoc('Orphanages', current.latitude, current.longitude, 2000);
      setState(() {
        nearbymarkers1 = ll;
      });
    }
    if (type == 2) {
      List ll = await getLoc(
          'Old+Age+Homes', current.latitude, current.longitude, 2000);
      setState(() {
        nearbymarkers2 = ll;
      });
    }
    if (type == 3) {
      List ll = await getLoc('NGO', current.latitude, current.longitude, 2000);
      setState(() {
        nearbymarkers3 = ll;
      });
    }

    if (type == 1) {
      nearbymarkers1.forEach((element) {
        community1.add(element);
      });
    }
    if (type == 2) {
      nearbymarkers2.forEach((element) {
        community2.add(element);
      });
    }
    if (type == 3) {
      nearbymarkers3.forEach((element) {
        community3.add(element);
      });
    }

    setState(() {
      community = {};
      type == 1 ? community = community.union(community1) : null;
      type == 2 ? community = community.union(community2) : null;
      type == 3 ? community = community.union(community3) : null;
    });
    // print(community);
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List temp = community.toList();

    print(temp.length);
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  belongtolinkspace
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              type = 0;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: const Text("Neighbourhood"),
                            ),
                          ),
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type = 1;
                      });
                      setmarkers();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 20,
                        width: 150,
                        child: const Text("Orphanage"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type = 2;
                      });
                      setmarkers();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: const Text("Old Age Homes"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type = 3;
                      });
                      setmarkers();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: const Text("Non-governmental organization"),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // UI edit

            // ListView.builder(
            //     itemCount: temp.length,
            //     shrinkWrap: true,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         child: Row(
            //           children: [
            //             Container(
            //               height: 80,
            //               width: 80,
            //               child: Image.network(temp[index]["icon"]),
            //             ),
            //             Container(
            //               height: 150,
            //               width: 250,
            //               child: Column(
            //                 children: [
            //                   Text(temp[index]["name"]),
            //                   Text("hjghgjhkj"),
            //                   Text(temp[index]["formatted_address"]),
            //                 ],
            //               ),
            //             )
            //           ],
            //         ),
            //       );
            //     })
          ],
        ));
  }

  getLoc(String query, double lat, double lng, double radius) async {
    print('https://maps.googleapis.com/maps/api/place/textsearch/json?query=' +
        query +
        '&location=' +
        lat.toString() +
        ',' +
        lng.toString() +
        '&radius=' +
        radius.toString() +
        '&key=AIzaSyBnUiYa_7RlPXxh5szOCfxyj2l9Wlb7HU4');
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

    return jsonStudent["results"];
  }

  getLocation() async {
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
    ;
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      current = LatLng(position.latitude, position.longitude);
    });
  }
}
