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
    return const Center(
      child: Text("Dashboard"),
    );
  }
}
