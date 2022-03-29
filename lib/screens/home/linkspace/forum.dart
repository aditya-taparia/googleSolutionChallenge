import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/linkspace/forumscreen.dart';
import 'package:googlesolutionchallenge/screens/home/linkspace/linkspacechat.dart';

class Forum extends StatefulWidget {
  final String id;
  final String name;
  const Forum({Key? key, required this.id, required this.name}) : super(key: key);

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
          title: Text(widget.name),
          // centerTitle: false,
          bottom: const TabBar(indicatorColor: Colors.white, unselectedLabelColor: Colors.white70, tabs: [
            Tab(
              child: Text(
                'Forum',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Tab(
                child: Text(
              'Group Chat',
              style: TextStyle(fontSize: 20),
            )),
          ]),
        ),
        body: TabBarView(
          children: [
            ForumScreen(id: widget.id),
            Linkspacechat(id: widget.id),
          ],
        ),
      ),
    );
  }
}
