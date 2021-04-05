// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smartizen/Repository/url_provider.dart';
import 'package:smartizen/Screens/Home.dart';

// ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
//   final prefs = await SharedPreferences.getInstance();
//   final String storeUser = prefs.getString('user');
//   final user = storeUser != null ? json.decode(storeUser) : null;
//   store.dispatch(GetUserAction(user));
// };

ThunkAction<AppState> signin(context, String email, String password) {
  Map data = {'email': email, 'password': password};
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jsonResponse;

    var response = await http.post(UrlProvider.login, body: data);
    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        sharedPreferences.setString("token", jsonResponse['token']);
        store.dispatch(GetUserAction(jsonResponse["user"]));

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            ModalRoute.withName('/Home'));
      }
    } else {
      print(response.body);
    }
  };
}

ThunkAction<AppState> auth() {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var jsonResponse;

    var response = await http.get(UrlProvider.auth, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        store.dispatch(GetUserAction(jsonResponse["user"]));
      }
    } else {
      print(response.body);
    }
  };
}

class GetUserAction {
  final dynamic _user;
  dynamic get user => this._user;
  GetUserAction(this._user);
}
