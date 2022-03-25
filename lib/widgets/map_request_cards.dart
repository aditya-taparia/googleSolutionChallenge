import 'package:flutter/material.dart';

class MapRequestCard extends StatelessWidget {
  final String title;
  final String description;
  final String postType;
  final String givenBy;
  final double promisedAmount;
  const MapRequestCard({
    Key? key,
    required this.title,
    required this.description,
    required this.postType,
    required this.givenBy,
    required this.promisedAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(66, 103, 178, 1),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Chip(
              avatar: const Icon(
                Icons.category_rounded,
                size: 16,
                color: Color.fromRGBO(66, 103, 178, 1),
              ),
              label: Text(
                postType,
                style: const TextStyle(
                  color: Color.fromRGBO(66, 103, 178, 1),
                ),
              ),
              backgroundColor: Colors.blue[50],
            ),
            const SizedBox(height: 8),
            Text(
              'Given by: $givenBy',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Promised Amount: ₹ ${promisedAmount.toString()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: const Color.fromRGBO(66, 103, 178, 1),
                    ),
                    child: const Text('More Details'),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(66, 103, 178, 1),
                    ),
                    child: const Text('Chat'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
