import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/utils/notification.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:googlesolutionchallenge/widgets/dash_cards.dart';
import 'package:googlesolutionchallenge/widgets/info_cards.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

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
    final value = await GeoCode()
        .reverseGeocoding(latitude: point.latitude, longitude: point.longitude);
    return value.region!;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
        .collection('Userdata')
        .doc(user!.userid)
        .snapshots();
    return Stack(
      children: [
        Image.asset(
          "assets/bgscaffold.jpeg",
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        FloatingSearchBar(
          clearQueryOnClose: true,
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOutCubic,
          physics: const BouncingScrollPhysics(),
          borderRadius: BorderRadius.circular(25),
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
          body: StreamBuilder<DocumentSnapshot>(
              stream: _userStream,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Object?>> userSnapshot) {
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
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Intro Text
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24.0,
                                10.0,
                                4.0,
                                0.0,
                              ),
                              child: Text(
                                'Hello ${userSnapshot.data!['name']}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(66, 103, 178, 1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24.0,
                                4.0,
                                4.0,
                                0.0,
                              ),
                              child: FutureBuilder<String>(
                                  future:
                                      getPlace(userSnapshot.data!['location']),
                                  initialData: 'No Location',
                                  builder: (context, geodata) {
                                    try {
                                      if (geodata.connectionState ==
                                          ConnectionState.waiting) {
                                        return Row(
                                          children: const [
                                            SizedBox(
                                              child: CircularProgressIndicator(
                                                color: Color.fromRGBO(
                                                    66, 103, 178, 1),
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
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      if (geodata.connectionState ==
                                          ConnectionState.done) {
                                        try {
                                          if (geodata.hasData) {
                                            return Text(
                                              geodata.data!,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                              'Location Not Found',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
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
                                                color: Color.fromRGBO(
                                                    66, 103, 178, 1),
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
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    } catch (e) {
                                      rethrow;
                                    }
                                  }),
                            ),

                            // Status Cards
                            const SizedBox(
                              height: 15,
                            ),

                            DefaultTabController(
                                length: 2,
                                child: Column(children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 225,
                                        child: TabBar(
                                          indicator:
                                              const UnderlineTabIndicator(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    66, 103, 178, 1),
                                                width: 4.0),
                                            insets: EdgeInsets.only(
                                                left: 10, right: 80),
                                          ),
                                          tabs: [
                                            Tab(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: const [
                                                  Text("Service",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromRGBO(
                                                            66, 103, 178, 1),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Tab(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const [
                                                Text("Open Jobs",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromRGBO(
                                                          66, 103, 178, 1),
                                                    )),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.62,
                                    child: TabBarView(
                                      children: [
                                        Column(
                                          children: [
                                            FittedBox(
                                              child: Wrap(
                                                alignment: WrapAlignment.start,
                                                spacing: 0,
                                                runSpacing: 0,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      DashCard(
                                                        color: Color.fromRGBO(
                                                            111, 185, 143, 1),
                                                        width: 210.0,
                                                        height: 145.0,
                                                        title:
                                                            'Service Requests',
                                                        subtitle:
                                                            'Total Requests: 0\nLast Request Status: Pending',
                                                        subtitleFontSize: 12,
                                                      ),
                                                      DashCard(
                                                        color: Color.fromRGBO(
                                                            250, 103, 118, 1),
                                                        width: 210.0,
                                                        height: 145.0,
                                                        title:
                                                            'Service Provided',
                                                        subtitle:
                                                            'Total Services: 0\nLast Service Status: Success',
                                                        subtitleFontSize: 12,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      const DashCard(
                                                        color: Color.fromRGBO(
                                                            25, 148, 173, 1),
                                                        width: 150.0,
                                                        height: 160.0,
                                                        title:
                                                            'Community Service',
                                                        subtitle: '',
                                                        subtitleFontSize: 24,
                                                      ),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                      Card(
                                                        elevation: 2,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .all(8.0),
                                                        color: const Color
                                                                .fromRGBO(
                                                            102, 102, 102, 1),
                                                        child: InkWell(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(20),
                                                          ),
                                                          onTap: () {},
                                                          child: const SizedBox(
                                                            width: 150.0,
                                                            height: 60.0,
                                                            child: Center(
                                                              child: Text(
                                                                'See All',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    'Explore',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromRGBO(
                                                          66, 103, 178, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                InfoCard(
                                                  tag: 'QR Scanner',
                                                  icon: Icons
                                                      .qr_code_scanner_rounded,
                                                  hasIcon: true,
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                InfoCard(
                                                  tag: 'Requests Near You',
                                                  icon: Icons
                                                      .person_pin_circle_rounded,
                                                  hasIcon: true,
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                InfoCard(
                                                  tag: 'Friends',
                                                  icon: Icons
                                                      .person_search_rounded,
                                                  hasIcon: true,
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                InfoCard(
                                                  tag: 'Add item',
                                                  icon: Icons.add_card,
                                                  hasIcon: true,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          //height: 200,
                                          child: ListView(
                                            //scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            children: const [
                                              DashCard(
                                                color: Color.fromRGBO(
                                                    111, 185, 143, 1),
                                                width: 180.0,
                                                height: 200.0,
                                                title: 'Open Forum 1',
                                                subtitle:
                                                    'Open Forum 1 details',
                                                subtitleFontSize: 12,
                                              ),
                                              DashCard(
                                                color: Color.fromRGBO(
                                                    25, 148, 173, 1),
                                                width: 180.0,
                                                height: 200.0,
                                                title: 'Open Forum 2',
                                                subtitle:
                                                    'Open Forum 2 details',
                                                subtitleFontSize: 12,
                                              ),
                                              DashCard(
                                                color: Color.fromRGBO(
                                                    250, 103, 118, 1),
                                                width: 180.0,
                                                height: 200.0,
                                                title: 'Open Forum 3',
                                                subtitle:
                                                    'Open Forum 3 details',
                                                subtitleFontSize: 12,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ])),

                            // User Interactions
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

    /* SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: Color.fromRGBO(66, 103, 178, 1),
                ),
                height: 130,
                padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hi Aditya",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Kerala, India",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 105, 8, 8),
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
                      hintText: "What are you looking for ?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.all(0),
                  color: Colors.blueGrey[50],
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          height: 140,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/addItem.png'),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.transparent,
                        elevation: 0,
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          height: 175,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add Items',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.redAccent[400],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.all(0),
                  color: Colors.blue[50],
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          height: 140,
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/earnings.png'),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.transparent,
                        elevation: 0,
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          height: 175,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Earnings',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(0),
              color: Colors.blue[50],
              child: Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: const Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/map.jpg'),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.black38,
                    elevation: 0,
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      height: 200,
                      width: double.maxFinite,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {
                          widget.bloc.changeNavigationIndex(Navigation.map);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'Explore Items Near You',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ); */
  }
}
