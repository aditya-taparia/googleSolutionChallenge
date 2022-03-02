import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/userdata.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';

class Dashboard extends StatefulWidget {
  final NavigationBloc bloc;
  final Userdata user;
  const Dashboard({Key? key, required this.bloc, required this.user})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  color: Color.fromRGBO(66, 103, 178, 1),
                ),
                height: 130,
                padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi ${widget.user.name}",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
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
    );
  }
}
