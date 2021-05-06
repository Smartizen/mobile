import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;

import "package:shared_preferences/shared_preferences.dart";
import 'package:smartizen/Components/RaiseRadientButton.dart';
import 'package:smartizen/Components/custom_nav_bar.dart';
import 'package:smartizen/Models/message_item.dart';
import 'package:smartizen/Models/notification_data.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Repository/url_provider.dart';
import 'package:smartizen/Screens/Group/Group.dart';
import 'package:smartizen/Screens/Profile/Profile.dart';
import 'package:smartizen/Screens/SignInScreen.dart';
import 'package:smartizen/Screens/Home/Component/room.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sharedPreferences;

  bool _isLoading = true;

  var items = new List<ListItem>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignInScreen()),
          ModalRoute.withName('/SignIn'));
    } else {
      checkfirebase();
    }
  }

  checkfirebase() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var notificationData = NotificationData.fromJson(message);
        print("onMessage: $message");
        //
        var newItem =
            new MessageItem(notificationData.title, notificationData.body);
        notifyNewItemInsert(newItem);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      sendTokenToServer(token);
    });
  }

  Future<String> createRoom(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    TextEditingController roomName = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Nhập tên phòng"),
            backgroundColor: Colors.blueGrey[50],
            content: TextField(
              controller: roomName,
              decoration: InputDecoration(hintText: "ví dụ : phòng khách"),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Gửi"),
                onPressed: () {
                  store.dispatch(createNewRoom(context, roomName.text));
                },
              )
            ],
          );
        });
  }

  fetchData() async {
    final store = StoreProvider.of<AppState>(context);

    await store.dispatch(auth(context));
    await store.dispatch(getHousesData(context, true));
    await store.dispatch(getDefaultHousesData(context));
    await store.dispatch(getMembersOfHouse(context));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff202227),
        body: Container(
            child: StoreConnector<AppState, AppState>(
                onInit: (store) {
                  fetchData();
                },
                converter: (store) => store.state,
                builder: (context, state) {
                  return _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // _createList(items),
                            Padding(
                              padding: EdgeInsets.only(left: 25, top: 30),
                              child: Text(
                                "Smart Home",
                                style: TextStyle(
                                    fontFamily: "SF Rounded",
                                    fontSize: 32,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    'assets/lightning.png',
                                    scale: 0.99,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "11.5",
                                              style: TextStyle(
                                                  fontFamily: "SF Rounded",
                                                  fontSize: 54,
                                                  fontWeight: FontWeight.w200,
                                                  color: Colors.white
                                                      .withOpacity(0.78)),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "°C",
                                              style: TextStyle(
                                                  fontSize: 28,
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "Nhiệt độ",
                                          style: TextStyle(
                                              fontFamily: 'SF Rounded',
                                              fontSize: 18,
                                              letterSpacing: 0.72,
                                              color: Colors.white
                                                  .withOpacity(0.15)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 29,
                                    child: Center(
                                      child: RaisedGradientButton(
                                          child: Text(
                                            'LOGOUT',
                                            style: TextStyle(
                                                fontFamily: "SF Rounded",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment(0.01, 0.13),
                                            end: Alignment(0.97, 0.84),
                                            colors: <Color>[
                                              Color(0xff79fd7b),
                                              Color(0xff3dcd98)
                                            ],
                                          ),
                                          onPressed: () {
                                            sharedPreferences.clear();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            SignInScreen()),
                                                    ModalRoute.withName(
                                                        '/SignIn'));
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              width: 413,
                              height: 106,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color: Colors.white.withOpacity(0.28)),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(children: [
                                Image.asset('assets/profile_pic.png'),
                                Container(
                                  padding: EdgeInsets.only(left: 2, right: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.user == null
                                            ? ""
                                            : state.user["lastname"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "SF Rounded",
                                            color: Colors.white),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.home,
                                            color:
                                                Colors.white.withOpacity(0.25),
                                          ),
                                          Text(
                                            state.defaultHouse == null
                                                ? ""
                                                : " " + state.defaultHouse.name,
                                            style: TextStyle(
                                                fontFamily: "SF Rounded",
                                                fontSize: 16,
                                                color: Colors.white
                                                    .withOpacity(0.25)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            Expanded(child: Room())
                          ],
                        );
                })),
        floatingActionButton: Transform.scale(
          scale: 1.1,
          child: Transform.translate(
            offset: Offset(0, 18),
            child: GestureDetector(
              onTap: () {
                createRoom(context).then((value) => print(value));
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0.5, 0),
                        end: Alignment(0.5, 1),
                        colors: [Color(0xff7afc79), Color(0xff3ccb97)]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 18,
                          color: Color(0xff7afc79).withOpacity(0.26))
                    ]),
                child: Image.asset(
                  'assets/plus.png',
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 18.0),
          child: ClipPath(
            clipper: NavbarClipper(),
            child: BottomAppBar(
              elevation: 0,
              color: Color(0xff3f4144).withOpacity(0.31),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.person_pin,
                        color: Colors.white.withOpacity(0.1),
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => Profile()),
                        );
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white.withOpacity(0.1),
                        size: 30,
                      ),
                      onPressed: null),
                  SizedBox(
                    height: 80,
                    width: 60,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.group,
                        color: Colors.white.withOpacity(0.1),
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => Group()),
                        );
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white.withOpacity(0.1),
                        size: 30,
                      ),
                      onPressed: null),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _createList(List<ListItem> data) {
    return Expanded(
        child: ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          title: item.buildTitle(context),
          subtitle: item.buildSubtitle(context),
        );
      },
    ));
  }

  void notifyNewItemInsert(ListItem newItem) {
    setState(() {
      items.insert(0, newItem);
    });
  }

  Future<void> sendTokenToServer(String deviceToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");

    Map<String, dynamic> data = {'token': deviceToken, 'platform': 'android'};

    var response = await http.post(UrlProvider.sendToken,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
