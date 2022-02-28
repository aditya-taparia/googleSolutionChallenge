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
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color.fromRGBO(66, 103, 178, 1)
                            .withOpacity(0.3),
                        blurRadius: 6.5,
                        spreadRadius: 1.0,
                        offset: const Offset(2.0, 8.0),
                      )
                    ],
                  ),
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: const Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                    size: 50.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "UserName",
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(66, 103, 178, 1),
                ),
              ),
              const Text(
                "examplename@company.com",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Wrap(runSpacing: 16, children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(66, 103, 178, 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/splashScreenDark.png',
                          height: 40,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "45 Link Points",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: view
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.light_mode),
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
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text(
                    'Add something here',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
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
                )
              ]),
            ]),
          ),
        );
        // screens to be displayed on screen
        final screens = [
          Dashboard(
            bloc: bloc,
          ),
          const MapScreen(),
          const Forum(),
          const Analytics()
        ];
        _index = snapshot.data!.index;
        return Scaffold(
          appBar: _index != 1
              ? AppBar(
                  // toolbarHeight: 122,
                  backgroundColor: Color.fromRGBO(66, 103, 178, 1),
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                      child: Column(
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              Text("Location detail",
                                  style: TextStyle(color: Colors.white))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                  // backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
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
                        : snapshot.data == Navigation.history
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
                    label: 'Forum',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.currency_rupee_rounded,
                    ),
                    selectedIcon: Icon(
                      Icons.currency_rupee_rounded,
                      color: Colors.white,
                    ),
                    label: 'Rewards',
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
