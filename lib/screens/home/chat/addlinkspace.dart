import 'package:flutter/material.dart';

class Addlinkspace extends StatefulWidget {
  const Addlinkspace({Key? key}) : super(key: key);

  @override
  State<Addlinkspace> createState() => _AddlinkspaceState();
}

double _slidervalue = 2;

class _AddlinkspaceState extends State<Addlinkspace> {
  @override
  Widget build(BuildContext context) {
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
                      keyboardType: TextInputType.text,
                      onSaved: (value) {},
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.group),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
              Row(
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
                            onPressed: () {}, child: const Icon(Icons.chat)),
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
                        child: ElevatedButton(
                            onPressed: () {}, child: const Icon(Icons.forum)),
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
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Icon(Icons.handshake)),
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
        onPressed: () {},
      ),
    );
  }
}
