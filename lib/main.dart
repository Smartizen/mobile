import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Redux/reducers.dart';
import 'package:smartizen/Screens/AddHouse/AddHouse.dart';
import 'package:smartizen/Screens/Group/Group.dart';

import 'package:smartizen/Screens/Home/Home.dart';
import 'package:smartizen/Screens/Houses/Houses.dart';
import 'package:smartizen/Screens/Profile/Profile.dart';
import 'package:smartizen/Screens/Rooms/Rooms.dart';
import 'package:smartizen/Screens/SignInScreen.dart';
import 'package:smartizen/Screens/SignUpScreen.dart';
import 'package:smartizen/Screens/Notification/Notification.dart';
import 'package:smartizen/Screens/UpdateProfile/UpdateProfile.dart';
import 'package:smartizen/utils/app_color.dart';

import 'package:smartizen/utils/app_logger.dart';

Future main() async {
  AppLogger()..isDebug = true;
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);

  await DotEnv().load('.env');
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Smart Home',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            canvasColor: AppColors.drawerBackgroundColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Home(),
          initialRoute: 'Home',
          routes: {
            'SignIn': (context) => SignInScreen(),
            'SignUp': (context) => SignUpScreen(),
            'Home': (context) => Home(),
            'Room': (context) => Rooms(),
            'Profile': (context) => Profile(),
            'AddHouse': (context) => AddHouse(),
            'Houses': (context) => Houses(),
            'Group': (context) => Group(),
            'UpdateProfile': (context) => UpdateProfile(),
            'Notification': (context) => NotificationBox()
          },
        ));
  }
}
