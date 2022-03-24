import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/request_form.dart';

class MapDataCard extends StatelessWidget {
  final String title;
  final Widget? actions;
  final String description;
  final String? moreInfo;
  final String? chip;
  final List<Widget> moreActions;
  final double elevation;
  const MapDataCard({
    Key? key,
    required this.title,
    this.actions,
    required this.description,
    this.moreInfo,
    this.chip,
    this.moreActions = const <Widget>[],
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.white,
            elevation: elevation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color.fromRGBO(66, 103, 178, 1),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      actions ?? Container()
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  chip != null
                      ? Chip(
                          label: Text(
                            chip!.toTitleCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 70,
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  moreInfo != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              moreInfo!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: moreActions,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
