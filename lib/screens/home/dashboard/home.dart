import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/widgets/loading_cards.dart';
import 'package:googlesolutionchallenge/widgets/request_data_cards.dart';
import 'package:googlesolutionchallenge/widgets/service_data_cards.dart';
import 'package:provider/provider.dart';

class DashHome extends StatefulWidget {
  const DashHome({Key? key}) : super(key: key);

  @override
  State<DashHome> createState() => _DashHomeState();
}

class _DashHomeState extends State<DashHome> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView(
          // physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            // Ongoing Services Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ongoing Services',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(66, 103, 178, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(110, 35),
                      padding: const EdgeInsets.all(0.0),
                    ),
                    // TODO: calendar page
                    onPressed: () {},
                    label: const Text(
                      'Calendar',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    icon: const Icon(
                      Icons.calendar_month_rounded,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .where('waiting-list', arrayContains: user!.userid)
                  .where('accepted-by', whereIn: ['', user.userid])
                  .where('payment-status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const LoadingCard();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingCard();
                }
                if (snapshot.data!.docs.length == 0) {
                  // TODO: No ongoing services Card
                  return const Text("No ongoing services");
                }

                // id: print(snapshot.data!.docs[0].id);
                // data: print(snapshot.data!.docs[0].data());
                // specific data: print(snapshot.data!.docs[0]['title']);
                List<Widget> cards = List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    return ServiceDataCard(
                      isAccepted: snapshot.data!.docs[index]['accepted-by'] ==
                          user.userid.toString(),
                      title: snapshot.data!.docs[index]['title'],
                      amount: snapshot.data!.docs[index]['promised-amount']
                          .toDouble(),
                      chatid: snapshot.data!.docs[index]['chat-id'],
                      description: snapshot.data!.docs[index]['description'],
                      expectedCompletionDate: snapshot.data!.docs[index]
                          ['expected-completion-time'],
                      givenBy: snapshot.data!.docs[index]['given-by-name'],
                      postid: snapshot.data!.docs[index].id,
                      status: snapshot.data!.docs[index]['completion-status'],
                    );
                  },
                  growable: true,
                );
                if (cards.length < 3) {
                  cards.add(
                    const SizedBox(
                      width: 150,
                      child: Center(
                        child: Text(
                          'See More',
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 270,
                  width: double.infinity,
                  child: ListView(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      bottom: 4.0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: cards,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Accepted Requests Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Active Requests',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(15, 157, 88, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .where('given-by', isEqualTo: user.userid)
                  .where('completion-status', isEqualTo: 'ongoing')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const LoadingCard();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingCard();
                }
                if (snapshot.data!.docs.length == 0) {
                  // TODO: No ongoing services Card
                  return const Text("No Active Requests");
                }

                List<Widget> requestcards = List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    return RequestDataCard(
                      title: snapshot.data!.docs[index]['title'],
                      amount: snapshot.data!.docs[index]['promised-amount']
                          .toDouble(),
                      description: snapshot.data!.docs[index]['description'],
                      completionDate: snapshot.data!.docs[index]
                          ['expected-completion-time'],
                      requestId: snapshot.data!.docs[index].id,
                      requestStatus: snapshot.data!.docs[index]
                          ['completion-status'],
                    );
                  },
                  growable: true,
                );
                if (requestcards.length < 3) {
                  requestcards.add(
                    const SizedBox(
                      width: 150,
                      child: Center(
                        child: Text(
                          'Add More',
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 215,
                  width: double.infinity,
                  child: ListView(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      bottom: 4.0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: requestcards,
                  ),
                );
              },
            ),

            // Explore
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(250, 103, 117, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
