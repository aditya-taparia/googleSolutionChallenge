import 'dart:math';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  final String amount;
  final String name;

  const Payment({
    Key? key,
    required this.amount,
    required this.name,
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;
  Color randomcolor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment for Item Request',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 38.0),
            child: Center(
              child: Text(
                'Paying Securely Using Gpay to',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 200),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: randomcolor,
                    child: Text(
                      widget.name[0],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'Promised Amount : ₹ ${widget.amount}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.00), color: Colors.blue[50]),
                width: MediaQuery.of(context).size.width - 60,
                height: 70,
                child: GestureDetector(
                  onHorizontalDragUpdate: (event) async {
                    if (event.primaryDelta! > 10) {
                      pay();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.translate(
                        offset: Offset(translateX, translateY),
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear,
                            width: 70 + myWidth,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.00),
                              color: Colors.green,
                            ),
                            child: myWidth > 0.0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      Flexible(
                                        child: Text(
                                          " Payment successful ",
                                          style: TextStyle(color: Colors.white, fontSize: 20.00),
                                        ),
                                      ),
                                    ],
                                  )
                                : const CircleAvatar(child: Image(image: AssetImage('assets/pay.png')), radius: 50, backgroundColor: Colors.white)),
                      ),
                      myWidth == 0.0
                          ? const Expanded(
                              child: Center(
                                child: Text(
                                  "Swipe to pay",
                                  style: TextStyle(color: Colors.blue, fontSize: 20.00),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pay() async {
    int k = -1;
    for (var i = 0; k == -1; i++) {
      await Future.delayed(const Duration(milliseconds: 1), () {
        setState(() {
          if (translateX + 1 < MediaQuery.of(context).size.width - (130 + myWidth)) {
            translateX += 1;
            myWidth = MediaQuery.of(context).size.width - (130 + myWidth);
          } else {
            k = 1;
          }
        });
      });
    }
  }
}
