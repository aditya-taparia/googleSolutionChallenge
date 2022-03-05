import 'dart:math';
import 'package:flutter/cupertino.dart';

final _random = Random();
double opacity = 1;

List<Color> Randomcolorlist = [
  Color.fromRGBO(104, 68, 156, opacity), //purple
  Color.fromRGBO(8, 148, 140, opacity), //green
  Color.fromRGBO(48, 64, 196, opacity) //blue
];

class Randomcol {
  getcolor() {
    return Randomcolorlist[_random.nextInt(Randomcolorlist.length)];
  }
}
