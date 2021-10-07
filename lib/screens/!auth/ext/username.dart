import 'package:demo_gram/screens/!auth/ext/signup.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:flutter/material.dart';

class Username extends StatefulWidget {
  const Username({Key? key}) : super(key: key);

  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    final Size size = MediaQuery.of(context).size;
    Map _userData = AppStateScope.of(context).userData;
    final TextEditingController _cont =
        TextEditingController(text: _userData['fullName']);
    bool validated = false;

    PreferredSizeWidget _appBar() {
      return PreferredSize(
        child: Container(),
        preferredSize: Size(size.width, size.height * 0.075),
      );
    }

    Widget _bodyContent() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: const Text(
                  'CREATE USERNAME',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: const Text(
                  'Add a username or use our suggestion. You can change this at any time.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: TextFormField(
                  controller: _cont,
                  cursorColor: Colors.white54,
                  cursorWidth: 1,
                  keyboardType: TextInputType.name,
                  validator: (String? v) {
                    if (v!.isEmpty || v.length < 3) {
                      return 'Please enter a username of at least 3 characters';
                    } else {
                      setState(() {
                        validated = true;
                      });
                    }
                  },
                  style: const TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.white54),
                    suffixIcon: !validated
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState == null) {
                      print("_formKey.currentState is null!");
                      setState(() {
                        validated = false;
                      });
                    } else if (_formKey.currentState!.validate()) {
                      if (validated) {
                        AppStateWidget.of(context)
                            .updateUserData({"username": _cont.text});
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const SignUp()));
                      }
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.black,
      body: _bodyContent(),
    );
  }
}
