import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/services/navigation_bloc.dart';

class Dashboard extends StatefulWidget {
  final NavigationBloc bloc;
  const Dashboard({Key? key, required this.bloc}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Color.fromRGBO(66, 103, 178, 1),
                  ),
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                    child: Text(
                      "Hi Som Sagar!",
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 105, 8, 8),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  onSaved: (value) {},
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "What are you looking for ?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
