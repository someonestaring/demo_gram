import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:demo_gram/screens/!auth/ext/birthday.dart';

class Next extends StatefulWidget {
  const Next({Key? key}) : super(key: key);

  @override
  _NextState createState() => _NextState();
}

class _NextState extends State<Next> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  bool _checkValue = true;
  bool _validated = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    PreferredSizeWidget _appBar() {
      return PreferredSize(
        child: const Center(
          child: Text(
            '',
          ),
        ),
        preferredSize: Size(size.width, size.height * 0.015),
      );
    }

    Widget _bodyContent() {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'NAME AND PASSWORD',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: TextFormField(
                    controller: _nameCont,
                    validator: (String? value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'Please enter at least 3 characters.';
                      } else {
                        setState(() {
                          _validated = true;
                        });
                      }
                    },
                    style: const TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      alignLabelWithHint: true,
                      hintStyle: const TextStyle(color: Colors.white38),
                      hintText: 'Full name',
                    ),
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passCont,
                  validator: (String? value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Please enter at least 6 characters.';
                    } else {
                      setState(() {
                        _validated = true;
                      });
                    }
                  },
                  style: const TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    alignLabelWithHint: true,
                    hintStyle: const TextStyle(color: Colors.white38),
                    hintText: 'Password',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _checkValue,
                      onChanged: (bool? type) {
                        setState(() {
                          _checkValue = !_checkValue;
                        });
                      },
                    ),
                    const Text(
                      'Remember password',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      //needs to gain access to device.contacts, scrape numbers || emails, snapshot && friend request known users
                      if (_formKey.currentState == null) {
                        print("_formKey.currentState is null!");
                      } else if (_formKey.currentState!.validate()) {
                        if (_validated) {
                          AppStateWidget.of(context).updateUserData({
                            'fullName': _nameCont.text,
                          });
                          AppStateWidget.of(context)
                              .updateMiscData({'password': _passCont.text});
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Birthday()));
                        }
                      }
                    },
                    child: const Text(
                        'Continue and Sync Contacts(not yet actually)'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState == null) {
                      print("_formKey.currentState is null!");
                    } else if (_formKey.currentState!.validate()) {
                      if (_validated) {
                        AppStateWidget.of(context).updateUserData({
                          'fullName': _nameCont.text,
                        });
                        AppStateWidget.of(context)
                            .updateMiscData({'password': _passCont.text});
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Birthday()));
                      }
                    }
                  },
                  child: const Text('Continue without Syncing Contacts'),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your contacts will be periodically synced and stored on Demo_Gram servers to help you and others find friends, and to help us provide a better service. To remove contacts, go to Settings and disconnect.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Learn More.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _bottomNav() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your contacts will be periodically synced and stored on Demo_Gram servers to help you and others find friends, and to help us provide a better service. To remove contacts, go to Settings and disconnect.',
            style: TextStyle(color: Colors.white70),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Learn More.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.black,
      // bottomNavigationBar: _bottomNav(), // TODO i think this was breaking due to overflow ??
      body: _bodyContent(),
    );
  }
}
