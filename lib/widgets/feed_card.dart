import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String subtitle;
  final String description;
  final String date;
  final int likes;
  final int comments;
  final List<Widget> actions;
  const FeedCard({
    Key? key,
    this.leading,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.date,
    required this.likes,
    required this.comments,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: leading,
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: Text(date),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${likes.toString()} Likes',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${comments.toString()} Comments',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 0.2,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions,
            )
          ],
        ),
      ),
    );
  }
}
