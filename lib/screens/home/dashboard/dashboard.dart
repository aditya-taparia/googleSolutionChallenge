import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/dash_home.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/dash_feed.dart';
import 'package:googlesolutionchallenge/screens/utils/notification.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Dashboard extends StatefulWidget {
  final NavigationBloc bloc;
  const Dashboard({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Can use this to get the region
  Future<String>? getPlace(GeoPoint point) async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=' +
        position.latitude.toString() +
        ',' +
        position.longitude.toString() +
        '&key=AIzaSyBnUiYa_7RlPXxh5szOCfxyj2l9Wlb7HU4'));

    final json = await jsonDecode(response.body);
    String location = json["results"][0]["address_components"][5]["long_name"].toString();
    return location;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final controller = FloatingSearchBarController();
    final Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance.collection('Userdata').doc(user!.userid).snapshots();
    return Stack(
      children: [
        Image.asset(
          "assets/bgscaffold.jpg",
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        FloatingSearchBar(
          controller: controller,
          title: DefaultTextStyle(
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            child: AnimatedTextKit(
              onTap: () {
                controller.open();
              },
              animatedTexts: [
                RotateAnimatedText('Search for items near you'),
                RotateAnimatedText('Search for people near you'),
                RotateAnimatedText('Search for linkspaces near you'),
              ],
              repeatForever: true,
            ),
          ),
          clearQueryOnClose: true,
          transition: CircularFloatingSearchBarTransition(),
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
          backgroundColor: const Color.fromRGBO(243, 243, 243, 1),
          openAxisAlignment: 0.0,
          axisAlignment: 0.0,
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
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        controller.query = "Surat";
                      },
                      leading: Icon(
                        Icons.history_rounded,
                        color: Colors.grey[600],
                      ),
                      title: Text(
                        'Surat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.history_rounded,
                        color: Colors.grey[600],
                      ),
                      title: Text(
                        'Search History - 2',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.history_rounded,
                        color: Colors.grey[600],
                      ),
                      title: Text(
                        'Search History - 3',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          body: StreamBuilder<DocumentSnapshot>(
              stream: _userStream,
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                }
                if (userSnapshot.hasData) {
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    body: DefaultTabController(
                      length: 2,
                      child: NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverOverlapAbsorber(
                              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              sliver: SliverAppBar(
                                stretch: true,
                                automaticallyImplyLeading: false,
                                backgroundColor: Colors.transparent,
                                flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.pin,
                                  centerTitle: false,
                                  titlePadding: const EdgeInsets.only(
                                    bottom: 70.0,
                                    left: 26.0,
                                    right: 10.0,
                                  ),
                                  title: FittedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello ${userSnapshot.data!['name']}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(66, 103, 178, 1),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        FutureBuilder<String>(
                                            future: getPlace(userSnapshot.data!['location']),
                                            initialData: 'No Location',
                                            builder: (context, geodata) {
                                              try {
                                                if (geodata.connectionState == ConnectionState.waiting) {
                                                  return Row(
                                                    children: const [
                                                      SizedBox(
                                                        child: CircularProgressIndicator(
                                                          color: Color.fromRGBO(66, 103, 178, 1),
                                                          strokeWidth: 1.5,
                                                        ),
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        'Getting Location...',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(102, 102, 102, 1),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                                if (geodata.connectionState == ConnectionState.done) {
                                                  try {
                                                    if (geodata.hasData) {
                                                      return Text(
                                                        geodata.data!,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(102, 102, 102, 1),
                                                        ),
                                                      );
                                                    } else {
                                                      return const Text(
                                                        'Location Not Found',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(102, 102, 102, 1),
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    rethrow;
                                                  }
                                                } else {
                                                  return Row(
                                                    children: const [
                                                      SizedBox(
                                                        child: CircularProgressIndicator(
                                                          color: Color.fromRGBO(66, 103, 178, 1),
                                                          strokeWidth: 2.5,
                                                        ),
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        'Getting Location...',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Color.fromRGBO(102, 102, 102, 1),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              } catch (e) {
                                                rethrow;
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                expandedHeight: 150,
                                floating: true,
                                pinned: true,
                                snap: false,
                                forceElevated: false,
                                bottom: PreferredSize(
                                  preferredSize: const Size.fromHeight(60),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TabBar(
                                      isScrollable: true,
                                      unselectedLabelColor: Colors.white,
                                      indicatorPadding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                      ),
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color.fromRGBO(239, 239, 239, 1),
                                      ),
                                      tabs: const [
                                        Tab(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                'Home',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                'Feed',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                        body: TabBarView(
                          children: [
                            DashHome(
                              bloc: widget.bloc,
                            ),
                            const DashFeed(),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const Loading();
              }),
        ),
      ],
    );
  }
}
