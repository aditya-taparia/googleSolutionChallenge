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

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: const Text("Orphanage"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type = 2;
                      });
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
            ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Text("aaa");
                })
          ],
        ));
  }

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
