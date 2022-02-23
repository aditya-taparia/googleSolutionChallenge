import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../home/home.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final pgcontroller = PageController();
  bool isLastPage = false;
  bool isFirstPage = true;
  @override
  void dispose() {
    pgcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: pgcontroller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
            setState(() => isFirstPage = index == 0);
          },
          children: [
            getstarted(),
            getstarted2(),
            getstarted3(),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: TextButton(
                  onPressed: () => pgcontroller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                  child: isFirstPage
                      ? const Text(
                          "",
                        )
                      : const Text(
                          "Back",
                          style: TextStyle(fontSize: 18),
                        )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
              child: Center(
                child: SmoothPageIndicator(
                  controller: pgcontroller,
                  count: 3,
                  onDotClicked: (index) => pgcontroller.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                ),
              ),
            ),
            isLastPage
                ? TextButton(
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home())),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 18),
                    ))
                : TextButton(
                    onPressed: () => pgcontroller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut),
                    child: const Text(
                      "      Next      ",
                      style: TextStyle(fontSize: 18),
                    ))
          ],
        ),
      ),
    );
  }
}

Widget getstarted() {
  return Container(
    color: Colors.blueAccent,
  );
}

Widget getstarted2() {
  return Container(
    color: Colors.amber,
  );
}

Widget getstarted3() {
  return Container(
    color: Colors.red,
  );
}
