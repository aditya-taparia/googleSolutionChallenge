import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/request_form.dart';
import 'package:googlesolutionchallenge/widgets/loading.dart';
import 'package:googlesolutionchallenge/widgets/request_data_cards.dart';
import 'package:provider/provider.dart';

class YourRequestPage extends StatefulWidget {
  const YourRequestPage({Key? key}) : super(key: key);

  @override
  State<YourRequestPage> createState() => _YourRequestPageState();
}

class _YourRequestPageState extends State<YourRequestPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .where('given-by', isEqualTo: user!.userid)
            .where('completion-status', isEqualTo: 'ongoing')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Loading();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('assets/active-request.png'),
                    fit: BoxFit.fitWidth,
                    height: 300,
                    width: 300,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'No Active Requests at the Moment!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(66, 103, 178, 1),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(66, 103, 178, 1),
                    ),
                    onPressed: () {},
                    label: const Text(
                      'Make a Request',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 18,
                    ),
                  ),
                ),
              ],
            );
          }

          List<Widget> requestcards = List.generate(
            snapshot.data!.docs.length,
            (index) {
              return RequestDataCard(
                title: snapshot.data!.docs[index]['title'],
                amount:
                    snapshot.data!.docs[index]['promised-amount'].toDouble(),
                description: snapshot.data!.docs[index]['description'],
                completionDate: snapshot.data!.docs[index]
                    ['expected-completion-time'],
                requestId: snapshot.data!.docs[index].id,
                requestStatus: snapshot.data!.docs[index]['completion-status'],
              );
            },
            growable: true,
          );
          if (requestcards.length < 3) {
            requestcards.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const RequestForm();
                    }));
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    strokeWidth: 2,
                    radius: const Radius.circular(10),
                    color: Colors.grey,
                    dashPattern: const [5, 5],
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_rounded,
                              size: 30,
                              color: Color.fromRGBO(111, 185, 143, 1),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Make a Request',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(111, 185, 143, 1),
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

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: requestcards,
          );
        },
      ),
    );
  }
}
