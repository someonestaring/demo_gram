import 'package:demo_gram/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demo_gram/screens/auth/utility.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Authority extends StatefulWidget {
  const Authority({Key? key}) : super(key: key);
  @override
  _AuthorityState createState() => _AuthorityState();
}

class _AuthorityState extends State<Authority> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _smsKey = GlobalKey<FormState>();
  final TextEditingController _signInCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  final TextEditingController _smsCont = TextEditingController();
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PhoneAuthCredential? _authCredential;
  bool verification = false;
  bool isActive = false;
  bool loading = false;
  String? phoneNumber;
  String? userEmail;
  String? _smsCode;
  String? _verId;

  @override
  void initState() {
    super.initState();
    _signInCont.addListener(_parseSignIn);
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    _signInCont.dispose();
    _passCont.dispose();
    _smsCont.dispose();
    super.dispose();
  }

  String _parseSignIn() {
    String input = _signInCont.text;
    final bool numPatt = RegExp(r'(\d+)').hasMatch(input);
    final bool emailPatt = RegExp(r'(\S+)@(\S+).(\w+)').hasMatch(input);
    List<Map<dynamic, dynamic>> _users = <Map<dynamic, dynamic>>[];
    _store.collection('users').get().then((QuerySnapshot snaps) {
      snaps.docs.forEach((doc) {
        Map<dynamic, dynamic> user = doc.data() as Map<dynamic, dynamic>;
        _users.add(user);
        _users.retainWhere((user) => user['username'].toString() == input);
      });
    });
    if (_users.isNotEmpty) {
      // handle username sign in --> if passCont == _users[0]['password'] --> login()
      // start here
      return 'username';
    }

    if (numPatt) {
      Future<String> getCountryCode() async {
        Future<bool> serviceEnabled;
        LocationPermission permission;
        serviceEnabled = Geolocator.isLocationServiceEnabled();
        if (serviceEnabled.toString() == 'false') {
          return Future.error('Location services are disabled.');
        }
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
          }
        }
        if (permission == LocationPermission.deniedForever) {
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final coordinates = Coordinates(position.latitude, position.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        return first.countryCode;
      }

      Future<String> countryCode = getCountryCode();
      setState(() {
        phoneNumber = '$countryCode${_signInCont.text}';
      });
      return 'number';
    } else if (emailPatt) {
      setState(() {
        userEmail = _signInCont.text;
      });
      return 'email';
    } else {
      return 'null';
    }
  }

  void _codeSent(String verificationId, int? resendToken) async {
    _showSMS(context);
    setState(() {
      loading = false;
      verification = true;
      _verId = verificationId;
    });
  }

  void _veriFailed(FirebaseAuthException e) {
    print('Verification FAILURE due to: $e');
  }

  void _veriCompleted(PhoneAuthCredential credential) async {
    try {
      setState(() {
        _authCredential = credential;
      });
      UserCredential user = await _auth.signInWithCredential(_authCredential!);
      if (user.user != null) {
        _store.collection("users").doc(user.user!.phoneNumber).update({
          'lastActive': DateTime.now(),
        });
        AppStateWidget.of(context).updateUserData({
          'lastActive': DateTime.now(),
        });
        print('User signed in, time to navigatge');
      }
    } catch (e) {
      print('_veriCompleted error: $e');
    }
  }

  void _autoRetrieval(String verificationId) {
    print('code auto-retrieval timeout --> verificationId --> $verificationId');
  }

  void _showSMS(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 3,
            actionsAlignment: MainAxisAlignment.center,
            scrollable: true,
            title: const Text('SMS Code:'),
            content: Form(
              key: _smsKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _smsCont,
                    style: const TextStyle(color: Colors.white38),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintStyle: const TextStyle(color: Colors.white38),
                      hintText: 'SMS Code',
                    ),
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp('[a-zA-Z]')) ||
                          value.length != 6) {
                        return 'Please use only 6 numbers';
                      } else {
                        setState(() {
                          _smsCode = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    _smsCode = _smsCont.text;
                  });
                  _continuePhoneSignIn();
                  print('this is the return string from _showSMS: $_smsCode');
                  Navigator.of(context).pop();
                  _smsCont.clear();
                  _signInCont.clear();
                  _passCont.clear();
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
  }

  Future<void> _continuePhoneSignIn() async {
    try {
      UserCredential? user = await _auth.signInWithCredential(_authCredential!);
      var boof = user.user;
      if (boof != null) {
        _store.collection("users").doc(user.user!.phoneNumber).update({
          'lastActive': DateTime.now(),
        });
        AppStateWidget.of(context).updateUserData({
          'lastActive': DateTime.now(),
        });
        print('User signed in, time to navigatge');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Utility()));
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print('Error on _continueRestistration. $e');
    }
  }

  void _logIn() async {
    setState(() {
      loading = true;
    });
    try {
      switch (_parseSignIn()) {
        case 'number':
          print('parses number');
          if (!verification) {
            await _auth.verifyPhoneNumber(
              timeout: const Duration(seconds: 60),
              phoneNumber: phoneNumber!,
              verificationCompleted: _veriCompleted,
              verificationFailed: _veriFailed,
              codeSent: _codeSent,
              codeAutoRetrievalTimeout: _autoRetrieval,
            );
          } else {
            setState(() {
              _authCredential = PhoneAuthProvider.credential(
                  verificationId: _verId!, smsCode: _smsCode!);
            });
          }
          return _continuePhoneSignIn();
        case 'username':
          return print('parses username');
        //handle username stuff
        case 'email':
          return print('parses email');
      }
    } catch (e) {
      print('Error on _login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: ,
      backgroundColor: Colors.black38,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Demo_Gram',
            style: GoogleFonts.dancingScript(
              textStyle: const TextStyle(
                  color: Colors.white70,
                  fontSize: 42.0,
                  // wordSpacing: 0.75,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _signInCont,
                    style: const TextStyle(color: Colors.white38),
                    decoration: InputDecoration(
                      // prefixText: '+1',
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintStyle: const TextStyle(color: Colors.white38),
                      hintText: 'Phone Number, Email, or Username',
                    ),
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp('[a-zA-Z]'))) {
                        return 'Please enter valid Phone Number, Email, or Username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passCont,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white38),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      alignLabelWithHint: true,
                      hintStyle: const TextStyle(color: Colors.white38),
                      hintText:
                          'Password', // not set up --> condition _numCont TFF to accept emails blah blah blah
                      suffixIcon: const Icon(
                        Icons.visibility_off,
                        color: Colors.white38,
                      ),
                    ),
                    validator: (String? value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter some text';
                      // }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          _logIn();
                        }
                      },
                      child: const Text('Log In'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Row(
          //   children: const [
          //     SizedBox(
          //       width: size.width * 0.28,
          //       child: DecoratedBox(
          //         decoration: BoxDecoration(
          //           border: Border(
          //             bottom: BorderSide(
          //               color: Colors.white54,
          //               width: 2,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      )),
    );
  }
}
