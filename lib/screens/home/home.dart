import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/models/userdata.dart';
import 'package:googlesolutionchallenge/screens/home/analytics/analytics.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/dashboard.dart';
import 'package:googlesolutionchallenge/screens/home/map/map.dart';
import 'package:googlesolutionchallenge/screens/home/chat/forum.dart';
import 'package:googlesolutionchallenge/services/auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:googlesolutionchallenge/services/userdatabase.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NavigationBloc bloc = NavigationBloc();
  final _auth = AuthService();

  int _index = 0;

  late bool view = false;

  @override
  void initState() {
    super.initState();
  }

// QR Generated
  bool qrgenerated = false;

//QR Scanner
  String result = "";
  Future qrscan() async {
    String scan = await FlutterBarcodeScanner.scanBarcode(
        '#336699', 'Cancel', true, ScanMode.QR);

    setState(() {
      result = scan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Navigation>(
      initialData: Navigation.dashboard,
      stream: bloc.currentNavigationIndex,
      builder: (context, snapshot) {
        // Drawer widget
        Widget _drawer = Drawer(
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(66, 103, 178, 1),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Text(
                                  'U',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromRGBO(66, 103, 178, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Username',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "examplename@company.com",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            splashColor: const Color.fromRGBO(79, 129, 188, 1),
                            onTap: () {
                              if (kDebugMode) {
                                print("Points");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 115, 177, 247),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: const Text(
                                "45 Link Points",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      bottom: 4.0,
                      top: 4.0,
                    ),
                    child: Text(
                      'About',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text(
                      'About Us',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {},
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey[600],
                    indent: 12.0,
                    endIndent: 12.0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      bottom: 4.0,
                      top: 4.0,
                    ),
                    child: Text(
                      'Personalize',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: view
                        ? const Icon(Icons.dark_mode_rounded)
                        : const Icon(Icons.light_mode_rounded),
                    title: const Text(
                      'Darkmode',
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Switch(
                      value: view,
                      onChanged: (bool active) {
                        setState(() {
                          view = active;
                          Global.shared.view = active;
                          active = !active;
                        });
                      },
                      activeColor: const Color.fromRGBO(66, 103, 178, 1),
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.grey,
                    ),
                    onTap: null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_rounded),
                    title: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {},
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey[600],
                    indent: 12.0,
                    endIndent: 12.0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      bottom: 4.0,
                      top: 4.0,
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "Logout",
                          ),
                          content: const Text(
                            "Are you sure you want to logout?",
                          ),
                          actions: <Widget>[
                            OutlinedButton(
                              child: const Text("Yes"),
                              onPressed: () async {
                                await _auth.signOut();
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              child: const Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          actionsAlignment: MainAxisAlignment.spaceAround,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  dense: true,
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.hub_rounded,
                      size: 35,
                      color: Color.fromRGBO(66, 103, 178, 1),
                    ),
                  ),
                  onTap: null,
                  title: Text(
                    'LINK',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Version 1.0.0 | By Team Aviato',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        final user = Provider.of<Users?>(context);

        return StreamBuilder<Userdata?>(
            // initialData: null,
            stream: UserDatabaseService(uid: user!.userid).userdata,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                print('waiting');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (userSnapshot.connectionState ==
                  ConnectionState.active) {
                print('active');

                print(userSnapshot.data);
                if (userSnapshot.hasData) {
                  print('has data');
                  Userdata? userdata = userSnapshot.data;
                  // screens to be displayed on screen
                  final screens = [
                    Dashboard(
                      bloc: bloc,
                      user: userdata!,
                    ),
                    const MapScreen(),
                    const Forum(),
                    const Analytics(),
                  ];
                  _index = snapshot.data!.index;

                  // TODO: Now we can checkif the user is provider or
                  // not and make changes accordingly

                  // TODO: check if the userSnapshot is null or not and
                  // show loading screen accorginly

                  return Scaffold(
                    appBar: _index != 1
                        ? AppBar(
                            elevation: 0,
                            // iconTheme: const IconThemeData(color: Colors.black),
                            actions: <Widget>[
                              IconButton(
                                tooltip: 'QR Code',
                                icon: const Icon(
                                  Icons.qr_code_rounded,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text(
                                          "QR Code",
                                        ),
                                        actions: <Widget>[
                                          Column(
                                            children: [
                                              qrgenerated == false
                                                  ? const Image(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/qr_code.jpg'),
                                                    )
                                                  : SizedBox(
                                                      height: 200,
                                                      width: 200,
                                                      child: QrImage(
                                                        data:
                                                            'eb3WylJkoTRbKqShhaqMfLs9Lzh1',
                                                      ),
                                                    ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  OutlinedButton(
                                                    child: Text(
                                                      !qrgenerated
                                                          ? "Generate"
                                                          : "Generated",
                                                      style: TextStyle(
                                                        color: !qrgenerated
                                                            ? Colors.blueGrey
                                                            : Colors
                                                                .blueGrey[200],
                                                      ),
                                                    ),
                                                    onPressed:
                                                        qrgenerated == false
                                                            ? () {
                                                                setState(() {
                                                                  qrgenerated =
                                                                      true;
                                                                });
                                                                if (kDebugMode) {
                                                                  print(
                                                                      qrgenerated);
                                                                }
                                                              }
                                                            : null,
                                                  ),
                                                  ElevatedButton(
                                                    child: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons
                                                              .qr_code_scanner_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("Scan"),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      // qrscan();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                        actionsAlignment:
                                            MainAxisAlignment.spaceAround,
                                      );
                                    }),
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: 'Notifications',
                                icon: const Icon(
                                  Icons.notifications_rounded,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                            backgroundColor:
                                const Color.fromRGBO(66, 103, 178, 1),
                          )
                        : null,
                    // Drawer styling from theme is left
                    drawer: _index != 1 ? _drawer : null,
                    body: SafeArea(
                      child: snapshot.data == Navigation.dashboard
                          ? screens[0]
                          : snapshot.data == Navigation.map
                              ? screens[1]
                              : snapshot.data == Navigation.disscussionForm
                                  ? screens[2]
                                  : snapshot.data == Navigation.analytics
                                      ? screens[3]
                                      : screens[0],
                    ),
                    bottomNavigationBar: Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: NavigationBarTheme(
                        data: Theme.of(context).navigationBarTheme,
                        child: NavigationBar(
                          animationDuration: const Duration(seconds: 1),
                          selectedIndex: _index,
                          onDestinationSelected: (_index) {
                            bloc.changeNavigationIndex(
                                Navigation.values[_index]);
                          },
                          destinations: const [
                            NavigationDestination(
                              icon: Icon(
                                Icons.dashboard_outlined,
                              ),
                              selectedIcon: Icon(
                                Icons.dashboard_rounded,
                                color: Colors.white,
                              ),
                              label: 'Dashboard',
                            ),
                            NavigationDestination(
                              icon: Icon(
                                Icons.share_location_rounded,
                              ),
                              selectedIcon: Icon(
                                Icons.share_location_rounded,
                                color: Colors.white,
                              ),
                              label: 'Map',
                            ),
                            NavigationDestination(
                              icon: Icon(
                                Icons.chat_bubble_outline_rounded,
                              ),
                              selectedIcon: Icon(
                                Icons.chat_bubble_rounded,
                                color: Colors.white,
                              ),
                              label: 'Chats',
                            ),
                            NavigationDestination(
                              icon: Icon(
                                Icons.insights_outlined,
                              ),
                              selectedIcon: Icon(
                                Icons.insights_rounded,
                                color: Colors.white,
                              ),
                              label: 'Analytics',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Loading();
                }
              } else {
                return const Loading();
              }
            });
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose(); // don't  forgot this.
    super.dispose();
  }
}

class Global {
  static final shared = Global();
  bool view = false;
}
