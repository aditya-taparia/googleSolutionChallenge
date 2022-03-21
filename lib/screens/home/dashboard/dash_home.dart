import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/history_page.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/request_form.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/your_request_page.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';
import 'package:googlesolutionchallenge/widgets/explore_item.dart';
import 'package:googlesolutionchallenge/widgets/loading_cards.dart';
import 'package:googlesolutionchallenge/widgets/no_data_card.dart';
import 'package:googlesolutionchallenge/widgets/service_data_cards.dart';
import 'package:provider/provider.dart';

class DashHome extends StatefulWidget {
  final NavigationBloc bloc;
  const DashHome({Key? key, required this.bloc}) : super(key: key);

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
                if (snapshot.data!.docs.isEmpty) {
                  return NoDataCard(
                    onTap: () {
                      widget.bloc.changeNavigationIndex(Navigation.map);
                    },
                    title: 'No Ongoing Services',
                    image: 'assets/ongoing-service.png',
                    subtitle: 'Search Nearby',
                    color: const Color.fromRGBO(66, 103, 178, 1),
                  );
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
                      paymentStatus: snapshot.data!.docs[index]
                          ['payment-status'],
                      postType: snapshot.data!.docs[index]['post-type'],
                    );
                  },
                  growable: true,
                );
                if (cards.length < 3) {
                  cards.add(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          widget.bloc.changeNavigationIndex(Navigation.map);
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          strokeWidth: 2,
                          radius: const Radius.circular(10),
                          color: Colors.grey,
                          dashPattern: const [5, 5],
                          child: SizedBox(
                            width: 150,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.explore_rounded,
                                    size: 30,
                                    color: Color.fromRGBO(66, 103, 178, 1),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'See More',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(66, 103, 178, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

            const SizedBox(height: 10),

            // Active Requests and History List Tile
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YourRequestPage(),
                    ),
                  );
                },
                tileColor: const Color.fromRGBO(111, 185, 143, 1),
                title: const Text(
                  'Your Requests',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                leading: const Icon(
                  Icons.checklist_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
                tileColor: const Color.fromRGBO(25, 149, 173, 1),
                title: const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                leading: const Icon(
                  Icons.history_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
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
                      color: Color.fromRGBO(66, 103, 178, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExploreItem(
                    title: 'QR Scanner',
                    backgroundColor: Colors.blue[50]!,
                    icon: Icons.qr_code_scanner_rounded,
                    iconColor: const Color.fromRGBO(66, 103, 178, 1),
                    onTap: () {},
                  ),
                  ExploreItem(
                    title: 'Community Service',
                    backgroundColor: Colors.red[50]!,
                    icon: Icons.volunteer_activism_rounded,
                    iconColor: const Color.fromRGBO(250, 103, 117, 1),
                    onTap: () {},
                  ),
                  ExploreItem(
                    title: 'Make a Request',
                    backgroundColor: Colors.purple[50]!,
                    icon: Icons.add_location_rounded,
                    iconColor: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RequestForm(),
                        ),
                      );
                    },
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
