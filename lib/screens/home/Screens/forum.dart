import 'package:flutter/material.dart';

class Forum extends StatefulWidget {
  const Forum({Key? key}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  child: Text(
                    'Forum',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Tab(
                    child: Text(
                  'Chats',
                  style: TextStyle(fontSize: 20),
                )),
              ]),
        ),
        body: TabBarView(children: [
          Center(
            child: Text('Forum'),
          ),
          Center(
            child: Text('Chats'),
          )
        ]),
      ),
    );
  }
}
