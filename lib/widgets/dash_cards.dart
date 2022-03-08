import 'package:flutter/material.dart';

class DashCard extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final String title;
  final String subtitle;
  final double subtitleFontSize;
  final Function()? onTap;
  const DashCard({
    Key? key,
    required this.color,
    required this.width,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.subtitleFontSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      margin: const EdgeInsets.all(8.0),
      color: color,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        onTap: onTap ?? () {},
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
