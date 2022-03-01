import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/Screens/analytics.dart';
import 'package:googlesolutionchallenge/screens/home/Screens/dashboard.dart';
import 'package:googlesolutionchallenge/screens/home/Screens/map.dart';
import 'package:googlesolutionchallenge/services/auth.dart';
import '../../services/navigation_bloc.dart';
import 'Screens/forum.dart';

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Navigation>(
      initialData: Navigation.dashboard,
      stream: bloc.currentNavigationIndex,
      builder: (context, snapshot) {
        // Drawer widget
        Widget _drawer = Drawer(
          child: ListView(
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
        );
        // screens to be displayed on screen
        final screens = [
          Dashboard(
            bloc: bloc,
          ),
          const MapScreen(),
          const Forum(),
          const Analytics(),
        ];
        _index = snapshot.data!.index;
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
                      onPressed: () {},
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
                  backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
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
                  bloc.changeNavigationIndex(Navigation.values[_index]);
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
