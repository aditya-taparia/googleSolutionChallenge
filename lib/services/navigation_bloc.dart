import 'dart:async';
import 'package:rxdart/rxdart.dart';

enum Navigation {
  dashboard,
  map,
  disscussionForm,
  analytics,
}

class NavigationBloc {
  final BehaviorSubject<Navigation> _navigationController =
      BehaviorSubject.seeded(Navigation.dashboard);

  Stream<Navigation> get currentNavigationIndex => _navigationController.stream;

  void changeNavigationIndex(Navigation navigation) {
    _navigationController.sink.add(navigation);
  }

  void dispose() {
    _navigationController.close();
  }
}
