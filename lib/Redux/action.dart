// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:smartizen/Components/application_box.dart';
import 'package:smartizen/Models/default_house.dart';
import 'package:smartizen/Models/houses.dart';
import 'package:smartizen/Models/members.dart';
import 'package:smartizen/Models/rooms.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smartizen/Repository/url_provider.dart';
import 'package:smartizen/Screens/Home/Home.dart';

////////////////////////////////////////////
/// User
////////////////////////////////////////////

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

////////////////////////////////////////////
/// House
////////////////////////////////////////////

ThunkAction<AppState> createHouse(context, String houseName, String location) {
  Map data = {
    'name': houseName,
    'location': location,
    'image': 'https://cdn.vuetifyjs.com/images/cards/sunshine.jpg'
  };

  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var jsonResponse;

    var response = await http.post(UrlProvider.createNewHouse,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data);
    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // TODO add to Farm array
    } else {
      print(response.body);
    }
  };
}

ThunkAction<AppState> getHousesData() {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var jsonResponse;

    var response = await http.get(UrlProvider.getHouses, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        store
            .dispatch(GetHousesAction(_loadHousesModel(jsonResponse["farms"])));
      }
    } else {
      print(response.body);
    }
  };
}

List<HousesModel> _loadHousesModel(houses) {
  final items = houses as List;
  return items.map((item) => HousesModel.fromJson(item)).toList();
}

class GetHousesAction {
  final List<HousesModel> _houses;
  List<HousesModel> get houses => this._houses;
  GetHousesAction(this._houses);
}

ThunkAction<AppState> getDefaultHousesData() {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var houseID = sharedPreferences.getString("houseID");
    var jsonResponse;

    var response =
        await http.get(UrlProvider.getHouseDetail(houseID), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        final members = jsonResponse["members"] as List;
        final rooms = jsonResponse["rooms"] as List;
        final _defaultHouse = DefaultHouse(
            id: jsonResponse["id"],
            name: jsonResponse["name"],
            image: jsonResponse["image"],
            location: jsonResponse["location"],
            members: members.map((member) => Members.fromJson(member)).toList(),
            rooms: rooms.map((room) => Rooms.fromJson(room)).toList(),
            roomBoxs: rooms
                .map((room) => ApplianceBox(
                      title: room["name"],
                      boxInfo: room["devices"].length.toString() + " Thiết bị",
                    ))
                .toList());
        store.dispatch(GetDefaultHouseAction(_defaultHouse));
      }
    } else {
      print(response.body);
    }
  };
}

class GetDefaultHouseAction {
  final DefaultHouse _defaultHouse;
  DefaultHouse get defaultHouse => this._defaultHouse;
  GetDefaultHouseAction(this._defaultHouse);
}
