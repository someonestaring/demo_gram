import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demo_gram/screens/auth/ext/body_ext/home_body.dart';
import 'package:demo_gram/screens/auth/ext/body_ext/search_body.dart';
import 'package:demo_gram/screens/auth/ext/body_ext/post_body.dart';
import 'package:demo_gram/screens/auth/ext/body_ext/activity_body.dart';
import 'package:demo_gram/screens/auth/ext/body_ext/profile_body.dart';
import 'package:demo_gram/state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _bodyNav = 'home';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // PageController _pageCont = AppStateScope.of(context).pageCont;

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
                  Row(children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _bodyNav = 'post';
                        });
                      },
                      icon: const Icon(
                        Icons.control_point_sharp,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _bodyNav = 'activity';
                        });
                      },
                      icon: const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AppStateWidget.of(context).toMessages();
                      },
                      icon: const Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ])
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
                setState(() {
                  _bodyNav = 'home';
                });
                print('homeNavIcon Pressed');
              },
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _bodyNav = 'search';
                });
                print('searchNavIcon Pressed');
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _bodyNav = 'post';
                });
                print('newPostNavIcon Pressed');
              },
              icon: const Icon(
                Icons.control_point_sharp,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _bodyNav = 'activity';
                });
                print('activityNavIcon Pressed');
              },
              icon: const Icon(
                Icons.favorite_border_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _bodyNav = 'profile';
                });
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
      switch (_bodyNav) {
        case 'home':
          return const Center(child: HomeBody());
        case 'activity':
          return const ActivityBody();
        case 'post':
          return const PostBody();
        case 'profile':
          return const ProfileBody();
        case 'search':
          return const SearchBody();
        default:
          return const HomeBody();
      }
    }

    return Scaffold(
      primary: true,
      appBar: _appBarContent(),
      bottomNavigationBar: _bottomNavContent(),
      body: _bodyContent(),
    );
  }
}
