import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthdayExplanation extends StatelessWidget {
  const BirthdayExplanation({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar(context) {
    Size size = MediaQuery.of(context).size;
    return PreferredSize(
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            const Text(
              'Birthdays',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      preferredSize: Size(size.width, size.height * 0.075),
    );
  }

  Widget _bodyContent(context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.cake_outlined,
            color: Colors.white,
            size: 125,
          ),
          const Text(
            'Birthdays On Demo_Gram',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const Text(
            'Providing your birthday improves the features and ads you see, and helps us keep the Demo_Gram community safe. You can find your birthday in your Personal Information Account Settings.',
            style: TextStyle(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              // handle "Learn More pop up"
              Navigator.of(context).pop();
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(context),
      body: _bodyContent(context),
    );
  }
}
