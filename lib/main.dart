import 'package:demo_gram/screens/splash.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo_Gram',
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
        ),
        home: const Splash(),
      ),
    );
  }
}
