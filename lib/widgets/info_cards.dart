import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String tag;
  final bool hasIcon;
  final IconData? icon;
  final String? image;
  final Function()? onTap;
  const InfoCard({
    Key? key,
    required this.tag,
    required this.hasIcon,
    this.icon,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 75.0,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(239, 239, 239, 1),
                border: Border.all(
                  color: const Color.fromRGBO(183, 183, 183, 1),
                  width: 1.0,
                ),
                image: !hasIcon
                    ? const DecorationImage(
                        image: AssetImage('assets/earnings.png'),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: hasIcon
                  ? Center(
                      child: Icon(
                        icon,
                        size: 30,
                        color: const Color.fromRGBO(66, 103, 178, 1),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 5.0),
          Center(
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
