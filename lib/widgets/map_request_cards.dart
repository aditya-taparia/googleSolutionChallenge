import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/chat/chatscreen.dart';
import 'package:googlesolutionchallenge/screens/home/chat/individualchat.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/more_details_page.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:provider/provider.dart';

class MapRequestCard extends StatefulWidget {
  final String title;
  final String description;
  final String postType;
  final String postId;
  final String givenBy;
  final double promisedAmount;
  final List<String> waitingList;
  final String chatId;
  final NavigationBloc bloc;
  const MapRequestCard({
    Key? key,
    required this.title,
    required this.description,
    required this.postType,
    required this.postId,
    required this.givenBy,
    required this.promisedAmount,
    required this.waitingList,
    required this.chatId,
    required this.bloc,
  }) : super(key: key);

  @override
  State<MapRequestCard> createState() => _MapRequestCardState();
}

class _MapRequestCardState extends State<MapRequestCard> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users?>(context);
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
                widget.title,
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
              widget.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/no_found.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.collections_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'See Images',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FittedBox(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          avatar: const Icon(
                            Icons.category_rounded,
                            size: 16,
                            color: Color.fromRGBO(66, 103, 178, 1),
                          ),
                          label: Text(
                            widget.postType,
                            style: const TextStyle(
                              color: Color.fromRGBO(66, 103, 178, 1),
                            ),
                          ),
                          backgroundColor: Colors.blue[50],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Given by: ${widget.givenBy}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Promised Amount: ₹ ${widget.promisedAmount.toString()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return MoreDetailsPage(postid: widget.postId);
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: widget.waitingList.contains(users!.userid.toString())
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onSurface: Colors.grey,
                            primary: const Color.fromRGBO(66, 103, 178, 1),
                          ),
                          child: const Text('Chat'),
                          onPressed: widget.chatId == ""
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return IndividualChat(
                                        id: widget.chatId,
                                      );
                                    }),
                                  );
                                },
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(66, 103, 178, 1),
                          ),
                          child: const Text('Accept Request'),
                          onPressed: () async {
                            FirebaseFirestore.instance.collection('Posts').doc(widget.postId).update({
                              'waiting-list': FieldValue.arrayUnion([users.userid.toString()])
                            }).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        color: Colors.green[800],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Request Sent to the owner',
                                        style: TextStyle(
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.green[50],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 3,
                                ),
                              );
                              widget.bloc.changeNavigationIndex(Navigation.dashboard);
                            });
                          },
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
