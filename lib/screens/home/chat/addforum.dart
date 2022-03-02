import 'dart:math';

import 'package:flutter/material.dart';

class Addforum extends StatefulWidget {
  const Addforum({Key? key}) : super(key: key);

  @override
  _AddforumState createState() => _AddforumState();
}

class _AddforumState extends State<Addforum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  child: const Text(
                    "S",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Som Sagar",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Location',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 300,
              //  color: Colors.black,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Post',
                  hintText: 'What do you want to talk about ?',
                ),
              ),
            ),
            const Spacer(),
            const Text(
              "Add Hashtag",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
