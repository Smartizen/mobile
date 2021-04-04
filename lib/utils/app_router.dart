import 'package:flutter_redux/flutter_redux.dart';

import 'package:smartizen/Screens/Home.dart';
import 'package:smartizen/Screens/Room.dart';
import 'package:smartizen/Screens/SignInScreen.dart';
import 'package:smartizen/Screens/SignUpScreen.dart';
// import 'package:smartizen/Store/app/app_state.dart';
// import 'package:smartizen/Store/auth/store.dart';

class AppRouter {
  static final homeRoute = '/';
  // static final loginRoute = '/login';
  // static final detailRoute = '/detail';

  static routes() {
    return {
      // homeRoute: (context) {
      //   return StoreConnector<AppState, AuthState>(
      //     converter: (store) => store.state.authState,
      //     builder: (_, authState) {
      //       if (authState.hasToken) {
      //         return Home();
      //       }
      //       return SignInScreen();
      //     },
      //   );
      // },
      'SignIn': (context) => SignInScreen(),
      'SignUp': (context) => SignUpScreen(),
      'Home': (context) => Home(),
      'Room': (context) => Room()
    };
  }
}
