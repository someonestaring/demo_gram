import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    PreferredSizeWidget? _appBarContent() {
      return PreferredSize(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Demo_Gram',
                    style: GoogleFonts.dancingScript(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          // wordSpacing: 0.75,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        print('message icon pressed');
                      },
                      icon: const Icon(
                        Icons.near_me_outlined,
                        color: Colors.white,
                      ))
                ],
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(size.height * 0.03),
      );
    }

    Widget? _bottomNavContent() {
      return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                print('homeNavIcon Pressed');
              },
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                print('searchNavIcon Pressed');
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                print('newPostNavIcon Pressed');
              },
              icon: const Icon(
                Icons.control_point_sharp,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                print('activityNavIcon Pressed');
              },
              icon: const Icon(
                Icons.favorite_border_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                print('profileNavIcon Pressed');
              },
              icon: const Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    Widget? _bodyContent() {
      return const Center(
        child: Text(
          'body content you stupid bitch',
        ),
      );
    }

    return Scaffold(
      primary: true,
      appBar: _appBarContent(),
      bottomNavigationBar: _bottomNavContent(),
      body: _bodyContent(),
    );
  }
}
