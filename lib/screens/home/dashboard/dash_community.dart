import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:http/http.dart' as http;

class CommunityService extends StatefulWidget {
  const CommunityService({Key? key}) : super(key: key);

  @override
  State<CommunityService> createState() => _CommunityServiceState();
}

class _CommunityServiceState extends State<CommunityService> {
  late LocationPermission permission;
  bool belongtolinkspace = false;
  late LatLng current;
  bool _isLoading = true;
//  late LatLng _current = const LatLng(15.5057, 80.0499);
  late List nearbymarkers1 = [];
  late List nearbymarkers2 = [];
  late List nearbymarkers3 = [];

  Future getLoc(String query, double lat, double lng, double radius) async {
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

    return jsonStudent["results"];
  }

  void setData() async {
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
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    current = LatLng(position.latitude, position.longitude);

    nearbymarkers1 = await getLoc('Orphanages', current.latitude, current.longitude, 2000);
    nearbymarkers2 = await getLoc('Old+Age+Homes', current.latitude, current.longitude, 2000);
    nearbymarkers3 = await getLoc('NGO', current.latitude, current.longitude, 2000);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community Service'),
          bottom: const TabBar(
            automaticIndicatorColorAdjustment: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Orphanages',
              ),
              Tab(
                text: 'Old Age Homes',
              ),
              Tab(
                text: 'NGO',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _isLoading
                ? const Loading()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: nearbymarkers1.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue[50],
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Color.fromRGBO(66, 103, 178, 1),
                              ),
                            ),
                            title: Text(
                              nearbymarkers1[index]['name'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              nearbymarkers1[index]['formatted_address'].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            _isLoading
                ? const Loading()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: nearbymarkers2.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.red[50],
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Color.fromRGBO(219, 68, 55, 1),
                              ),
                            ),
                            title: Text(
                              nearbymarkers2[index]['name'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              nearbymarkers2[index]['formatted_address'].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            _isLoading
                ? const Loading()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: nearbymarkers3.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.green[50],
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Color.fromRGBO(15, 157, 88, 1),
                              ),
                            ),
                            title: Text(
                              nearbymarkers3[index]['name'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              nearbymarkers3[index]['formatted_address'].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
