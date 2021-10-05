// import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:demo_gram/screens/!auth/ext/birth_ext.dart';

class Birthday extends StatefulWidget {
  const Birthday({Key? key}) : super(key: key);

  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  final DateTime _date = DateTime.now().toUtc();
  final List _months = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  PreferredSizeWidget _appBar(context) {
    Size size = MediaQuery.of(context).size;
    return PreferredSize(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.cake_outlined,
              color: Colors.white,
              size: 64,
            ),
          ],
        ),
      ),
      preferredSize: Size(size.width, size.height * 0.15),
    );
  }

  Widget _birthdayBox(context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        height: size.height * 0.05,
        width: size.width * 0.9,
        //color: Colors.grey[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                '${_months[_date.month - 1]} ${_date.day}, ${_date.year - 1}',
                style: const TextStyle(
                  // backgroundColor: Colors.grey,
                  color: Colors.white54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyContent(context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Add Your Birthday',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const BirthdayExplanation()));
            },
            child: const Text(
              "This won't be part of your public profile. \n Why do I need to provide my birthday?",
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _birthdayBox(context),
          const Spacer(),
          SizedBox(
            width: size.width,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // SizedBox(
          //   height: size.height * 0.25,
          //   width: size.width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ListWheelScrollView(
          //           physics: const ScrollPhysics(),
          //           magnification: 1.5,
          //           useMagnifier: true,
          //           diameterRatio: 0.75,
          //           itemExtent: size.height * 0.025,
          //           children: List.generate(
          //               11,
          //               (index) => Text(
          //                     _months[index],
          //                     style: const TextStyle(color: Colors.white70),
          //                   )))
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _bodyContent(context),
      appBar: _appBar(context),
    );
  }
}
