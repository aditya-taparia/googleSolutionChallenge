import 'dart:math';
import 'package:flutter/cupertino.dart';

final _random = Random();
double opacity = 1;

List<Color> Randomcolorlist = [
  Color.fromRGBO(72, 76, 252, opacity),
  Color.fromRGBO(8, 148, 140, opacity),
  Color.fromRGBO(72, 60, 228, opacity),
  Color.fromRGBO(32, 28, 100, opacity)
];

var element = Randomcolorlist[_random.nextInt(Randomcolorlist.length)];

class Randomcol {
  getcolor() {
    return element;
  }
}
