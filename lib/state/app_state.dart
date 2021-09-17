import 'package:flutter/material.dart';

final Map initialState = {
  "dateJoined": DateTime,
  "deviceTokens": [],
  "email": '',
  "firstName": 'New',
  "lastActive": DateTime,
  "lastName": 'User',
  "notificationAccess": false,
  "phoneNumber": '',
  "profilePhoto": '',
  "username": 'new_user',
};

final PageController _pageCont = PageController(
  initialPage: 0,
);

class AppState {
  AppState({
    required this.pageCont,
    required this.userData,
    required this.miscData,
  });
  final PageController pageCont;
  final Map userData;
  final Map miscData;

  AppState copyWith({
    PageController? pageCont,
    Map? userData,
    Map? miscData,
  }) {
    return AppState(
      pageCont: pageCont ?? this.pageCont,
      userData: userData ?? this.userData,
      miscData: miscData ?? this.miscData,
    );
  }
}

class AppStateScope extends InheritedWidget {
  const AppStateScope(this.data, {Key? key, required Widget child})
      : super(key: key, child: child);

  final AppState data;

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return data != oldWidget.data;
  }
}

class AppStateWidget extends StatefulWidget {
  const AppStateWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  static AppStateWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<AppStateWidgetState>()!;
  }

  @override
  AppStateWidgetState createState() => AppStateWidgetState();
}

class AppStateWidgetState extends State<AppStateWidget> {
  final AppState _data = AppState(
    pageCont: _pageCont,
    userData: initialState,
    miscData: {},
  );

  void updateUserData(Map newData) {
    setState(() {
      newData.forEach((key, value) {
        if (_data.userData.containsKey(key)) {
          _data.userData.update(key, (value) => value);
        } else {
          _data.userData[key] = value;
        }
      });
    });
  }

  void updateMiscData(Map newData) {
    setState(() {
      newData.forEach((key, value) {
        if (_data.miscData.containsKey(key)) {
          _data.miscData.update(key, (value) => value);
        } else {
          _data.miscData[key] = value;
        }
      });
    });
  }

  void backNav() {
    _pageCont.animateToPage(
      0,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.easeIn,
    );
  }

  void toMessages() {
    _pageCont.animateToPage(
      1,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(_data, child: widget.child);
  }
}
