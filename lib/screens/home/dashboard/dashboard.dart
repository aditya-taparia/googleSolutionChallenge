import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
        .collection('Userdata')
        .doc(user!.userid)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (userSnapshot.hasData) {
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  /* decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.blue[50]!,
                        const Color.fromRGBO(66, 103, 178, 1)
                      ],                      
                    ),
                  ), */
                  color: Colors.blue[50],
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hello ${userSnapshot.data!['name']}',
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${userSnapshot.data!['generalLocation']}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 0,
                  top: MediaQuery.of(context).size.height * 0.17,
                  child: SizedBox(
                    height: 200,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Card(
                          elevation: 2.5,
                          margin: const EdgeInsets.all(8.0),
                          color: Colors.orange[100],
                          child: const SizedBox(
                            width: 200.0,
                            height: 150.0,
                            child: Text('Text'),
                          ),
                        ),
                        Card(
                          elevation: 2.5,
                          margin: const EdgeInsets.all(8.0),
                          color: Colors.green[100],
                          child: const SizedBox(
                            width: 200.0,
                            height: 150.0,
                            child: Text('Text'),
                          ),
                        ),
                        Card(
                          elevation: 2.5,
                          margin: const EdgeInsets.all(8.0),
                          color: Colors.purple[100],
                          child: const SizedBox(
                            width: 200.0,
                            height: 150.0,
                            child: Text('Text'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(8),
                            strokeWidth: 1,
                            dashPattern: const [4, 4],
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.black,
                            child: SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add_rounded,
                                      size: 24,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'See More',
                                      style: TextStyle(
                                        fontSize: 18,
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
                  ),
                ),
                SizedBox.expand(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.4,
                    maxChildSize: 0.8,
                    expand: true,
                    snap: true,
                    snapSizes: const [0.8],
                    builder: ((context, _scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.2)),
                          ],
                        ),
                        child: SingleChildScrollView(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          controller: _scrollController,
                          child: Column(
                            children: [
                              Text('Welcome ${userSnapshot.data!['name']}',
                                  style: const TextStyle(fontSize: 20)),
                              Text('${userSnapshot.data!['email']}',
                                  style: const TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          }
          return const Loading();
        });

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
