import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final pgcontroller = PageController();
  bool isLastPage = false;
  bool isFirstPage = true;
  int numb = 0;
  @override
  void dispose() {
    pgcontroller.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    if (kDebugMode) {
      print("Shared pref called");
    }
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    if (kDebugMode) {
      print(prefs.getInt('onBoard'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: pgcontroller,
          onPageChanged: (index) {
            numb = index;
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
      bottomSheet: Container(
        height: 80,
        color: _setbottomcolor(numb),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: TextButton(
                onPressed: isFirstPage
                    ? null
                    : () {
                        pgcontroller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                child: isFirstPage
                    ? const Text(
                        "",
                      )
                    : const Text(
                        "Back",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
              child: Center(
                child: SmoothPageIndicator(
                  controller: pgcontroller,
                  count: 3,
                  onDotClicked: (index) {
                    pgcontroller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
            isLastPage
                ? TextButton(
                    onPressed: () {
                      _storeOnboardInfo();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Wrapper(),
                        ),
                      );
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : TextButton(
                    onPressed: () => pgcontroller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

Widget getstarted() {
  return Container(
    color: const Color.fromRGBO(198, 231, 255, 1),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Lottie.asset('assets/online.json'),
            const Text(
              "Connect with other linkers near you",
              style: TextStyle(
                fontSize: 23,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget getstarted2() {
  return Container(
    color: const Color.fromRGBO(209, 222, 252, 1),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Lottie.asset('assets/sbc.json'),
            const Text(
              "Lend, Borrow or Donate",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget getstarted3() {
  return Container(
    color: const Color.fromRGBO(221, 235, 255, 1),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Lottie.asset('assets/search_nearby.json'),
            const Text(
              "Find jobs near you",
              style: TextStyle(
                fontSize: 23,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

_setbottomcolor(int numb) {
  if (numb == 0) {
    return const Color.fromRGBO(198, 231, 255, 1);
  } else if (numb == 1) {
    return const Color.fromRGBO(209, 222, 252, 1);
  } else {
    return const Color.fromRGBO(221, 235, 255, 1);
  }
}
