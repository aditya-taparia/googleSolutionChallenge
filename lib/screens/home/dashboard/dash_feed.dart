import 'package:flutter/material.dart';

class DashFeed extends StatefulWidget {
  const DashFeed({Key? key}) : super(key: key);

  @override
  State<DashFeed> createState() => _DashFeedState();
}

class _DashFeedState extends State<DashFeed> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Feeds'),
    );
  }
}
