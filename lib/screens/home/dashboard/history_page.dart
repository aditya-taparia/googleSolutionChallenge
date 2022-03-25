import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text('Requests'),
              ),
              Tab(
                child: Text('Services'),
              ),
              Tab(
                child: Text('Charity'),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RequestHistory(),
            ServiceHistory(),
            CharityHistory(),
          ],
        ),
      ),
    );
  }
}

class RequestHistory extends StatefulWidget {
  const RequestHistory({Key? key}) : super(key: key);

  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('Posts').orderBy('expected-completion-time').where('given-by', isEqualTo: user!.userid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        if (snapshot.data!.docs.isEmpty) {
          return const NoFound(
            text: 'No Request History Found',
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: const Icon(
                      Icons.history_rounded,
                      color: Color.fromRGBO(66, 103, 178, 1),
                    ),
                  ),
                  onTap: () {},
                  tileColor: Colors.white,
                  title: Text(snapshot.data!.docs[index]['title']),
                  subtitle: Text(
                    snapshot.data!.docs[index]['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Color.fromRGBO(66, 103, 178, 1),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ServiceHistory extends StatefulWidget {
  const ServiceHistory({Key? key}) : super(key: key);

  @override
  State<ServiceHistory> createState() => _ServiceHistoryState();
}

class _ServiceHistoryState extends State<ServiceHistory> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Posts')
          .orderBy('expected-completion-time')
          .where('accepted-by', whereIn: ['', user!.userid])
          .where('waiting-list', arrayContains: user.userid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        if (snapshot.data!.docs.isEmpty) {
          return const NoFound(
            text: 'No Services History Found',
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: const Icon(
                      Icons.history_rounded,
                      color: Color.fromRGBO(66, 103, 178, 1),
                    ),
                  ),
                  onTap: () {},
                  tileColor: Colors.white,
                  title: Text(snapshot.data!.docs[index]['title']),
                  subtitle: Text(
                    snapshot.data!.docs[index]['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Color.fromRGBO(66, 103, 178, 1),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CharityHistory extends StatefulWidget {
  const CharityHistory({Key? key}) : super(key: key);

  @override
  State<CharityHistory> createState() => _CharityHistoryState();
}

class _CharityHistoryState extends State<CharityHistory> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Posts')
          .orderBy('expected-completion-time')
          .where('accepted-by', isEqualTo: user!.userid)
          .where('post-type', isEqualTo: 'charity')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        if (snapshot.data!.docs.isEmpty) {
          return const NoFound(
            text: 'No Charity History Found',
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: const Icon(
                      Icons.history_rounded,
                      color: Color.fromRGBO(66, 103, 178, 1),
                    ),
                  ),
                  onTap: () {},
                  tileColor: Colors.white,
                  title: Text(snapshot.data!.docs[index]['title']),
                  subtitle: Text(
                    snapshot.data!.docs[index]['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Color.fromRGBO(66, 103, 178, 1),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class NoFound extends StatelessWidget {
  final String text;
  const NoFound({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage(
            'assets/no_found.png',
          ),
          height: 250,
          width: 300,
          alignment: Alignment.center,
        ),
        const SizedBox(height: 20),
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
