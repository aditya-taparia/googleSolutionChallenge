import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/widgets/feed_card.dart';

class DashFeed extends StatefulWidget {
  const DashFeed({Key? key}) : super(key: key);

  @override
  State<DashFeed> createState() => _DashFeedState();
}

class _DashFeedState extends State<DashFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body:
          // Feed Card
          FeedCard(
        leading: CircleAvatar(
          backgroundColor:
              Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: const Text(
            'A',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        title: 'Title',
        subtitle: 'Subtitle',
        date: '1/1/1',
        description: 'Description',
        likes: 2,
        comments: 5,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_outline_rounded,
              color: Colors.pink,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.comment_rounded,
              color: Color.fromRGBO(66, 103, 178, 1),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.report_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
