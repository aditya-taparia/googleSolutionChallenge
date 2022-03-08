import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';

class Addlinkspace extends StatefulWidget {
  const Addlinkspace({Key? key}) : super(key: key);

  @override
  State<Addlinkspace> createState() => _AddlinkspaceState();
}

double _slidervalue = 2;
List<bool> isActive = [true, true, true];
int widgettype = 0;

class _AddlinkspaceState extends State<Addlinkspace> {
  final lncontroller = TextEditingController();
  final ldcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Linkspace"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      autofocus: false,
                      controller: lncontroller,
                      keyboardType: TextInputType.text,
                      onSaved: (value) {},
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.group),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Type Linkspace name ...",
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Provide a Linkspace name and an optional Icon",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                autofocus: false,
                controller: ldcontroller,
                keyboardType: TextInputType.text,
                maxLines: 5,
                onSaved: (value) {},
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Purpose of group",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              /* Row(
                children: const [
                  Text("Radius of visibilty"),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.info_rounded,
                    color: Colors.grey,
                    size: 20,
                  )
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Slider(
                value: _slidervalue,
                onChanged: (value) {
                  setState(() {
                    _slidervalue = value;
                  });
                },
                min: 0,
                max: 50,
                divisions: 25,
              ),
              _slidervalue >= 2
                  ? Text(_slidervalue.toInt().toString() + "km")
                  : const Text(
                      "Must be atleast 2 km",
                      style: TextStyle(color: Colors.red),
                    ),
              const SizedBox(
                height: 15,
              ),*/
              const SizedBox(
                height: 15,
              ),
              Row(
                children: const [
                  Text("Widgets to add"),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.info_rounded,
                    color: Colors.grey,
                    size: 20,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Icon(Icons.chat),
                          style: ElevatedButton.styleFrom(
                            onSurface: Colors.amber,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Chat",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widgettype = widgettype * 10 + 1;
                              isActive[1] = !isActive[1];
                            });
                          },
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  onSurface: Colors.grey),
                              onPressed: isActive[1]
                                  ? () {
                                      setState(() {
                                        isActive[1] = false;
                                      });
                                    }
                                  : null,
                              child: const Icon(Icons.forum)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Forum",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widgettype = widgettype * 10 + 2;
                              isActive[2] = !isActive[2];
                            });
                          },
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  onSurface: Colors.grey),
                              onPressed: isActive[2]
                                  ? () {
                                      setState(() {
                                        isActive[2] = false;
                                      });
                                    }
                                  : null,
                              child: const Icon(Icons.handshake)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Charity",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Chat is available as default | More widgets coming soon ",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Linkers"),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Column(
                    children: const [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        radius: 25,
                      ),
                      Text("Admin")
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.done,
        ),
        onPressed: () {
          String name = lncontroller.text;
          String purp = ldcontroller.text;
          int type = widgettype;
          String location = "IIIT Kottayam";
          String docname = user!.userid;
          createlinkspace(name, purp, type, docname, location);

          Navigator.pop(context);
        },
      ),
    );
  }

  Future createlinkspace(String name, String purp, int type, String docname,
      String location) async {
    final addedlinkspace =
        FirebaseFirestore.instance.collection("Linkspace").doc();

    final json = {
      'ownerid': docname,
      'name': name,
      'description': purp,
      'location': location,
      'type': type,
      'member': [docname],
    };

    await addedlinkspace.set(json);
  }
}
