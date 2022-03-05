import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/chat/forum.dart';

class linkspace extends StatefulWidget {
  const linkspace({Key? key}) : super(key: key);

  @override
  State<linkspace> createState() => _linkspaceState();
}

bool _isspaceowned = true;

List<String> tiletitles = [
  "Indian Institute Of Information Technology",
  "Google Solutions Challenge Workspace"
];
List<String> tiledescriptions = [
  "A linkspace dedicated to study flutter and develop futuristic apps for the betterment of the world",
  "A linkspace comprised of students from IIITK participating in GSC 2022"
];
List<String> tilelocation = ["Valavoor, Kottayam", "Valavoor, Kottayam"];
List<int> tilememeber = [546, 4];

class _linkspaceState extends State<linkspace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 2, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Linkspace",
                style: TextStyle(fontSize: 20),
              ),
              _isspaceowned
                  ? const Text(
                      "Check out what happening in your space",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  : const Text(
                      "Explore and find your ideal space",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  itemCount: tiletitles.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Forum()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          height: 180,
                          decoration: const BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.only(
                                  // topLeft: Radius.circular(10),
                                  topRight: Radius.circular(30))),
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 10,
                                  ),
                                  Text("Active")
                                ],
                              ),
                              ListTile(
                                leading: Column(
                                  children: [
                                    const Icon(Icons.group),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 45,
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(66, 103, 178, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                        child: Text(
                                          tilememeber[index].toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                title: Text(tiletitles[index]),
                                subtitle: SingleChildScrollView(
                                  child: Container(
                                      child: Text(tiledescriptions[index])),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(tilelocation[index]),
                                    const Icon(
                                      Icons.person_add,
                                      color: Color.fromRGBO(66, 103, 178, 1),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.group_add),
      ),
    );
  }
}
