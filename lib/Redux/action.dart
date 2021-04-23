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
import 'package:smartizen/Screens/AddHouse/AddHouse.dart';
import 'package:smartizen/Screens/Home/Home.dart';
import 'package:smartizen/Screens/Houses/Houses.dart';
import 'package:smartizen/Screens/SignInScreen.dart';

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

ThunkAction<AppState> signup(context, String email, String password,
    String firstname, String lastname, gender) {
  Map data = {
    'email': email,
    'password': password,
    'firstname': firstname,
    'lastname': lastname,
    'gender': gender.index == 0 ? "male" : "female",
  };
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jsonResponse;

    var response = await http.post(UrlProvider.signup, body: data);
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

ThunkAction<AppState> auth(context) {
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
    } else if (response.statusCode == 401) {
      sharedPreferences.clear();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignInScreen()),
          ModalRoute.withName('/SignIn'));
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

ThunkAction<AppState> createHouse(
    context, String houseName, double lat, double long) {
  Map data = {
    'name': houseName,
    'lat': lat.toString(),
    'long': long.toString(),
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
    print(response.statusCode);
    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse["data"];
      sharedPreferences.setString("houseID", jsonResponse["id"]);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => Houses()),
      );
      // TODO add to Farm array
    } else {
      print(response.body);
    }
  };
}

ThunkAction<AppState> deleteHouseAction(context, String houseID) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var jsonResponse;

    var response =
        await http.delete(UrlProvider.getHouseDetail(houseID), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      store.state.houses.removeWhere((houses) => houses.id == houseID);
      store.dispatch(GetHousesAction(store.state.houses));
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

ThunkAction<AppState> getDefaultHousesData(context) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var isHaveHouse = sharedPreferences.containsKey('houseID');
    if (isHaveHouse) {
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
        jsonResponse = jsonResponse["farm"];

        if (jsonResponse != null) {
          final members = jsonResponse["members"] as List;
          final rooms = jsonResponse["rooms"] as List;
          final _defaultHouse = DefaultHouse(
              id: jsonResponse["id"],
              name: jsonResponse["name"],
              image: jsonResponse["image"],
              lat: jsonResponse["lat"],
              long: jsonResponse["long"],
              members:
                  members.map((member) => Members.fromJson(member)).toList(),
              rooms: rooms.map((room) => Rooms.fromJson(room)).toList(),
              roomBoxs: rooms
                  .map((room) => ApplianceBox(
                        title: room["name"],
                        boxInfo:
                            room["devices"].length.toString() + " Thiết bị",
                        roomId: room["id"],
                      ))
                  .toList());
          store.dispatch(GetDefaultHouseAction(_defaultHouse));
        } else {
          sharedPreferences.remove("houseID");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => AddHouse()),
          );
        }
      } else {
        print(response.body);
      }
    } else {
      sharedPreferences.remove("houseID");
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => AddHouse()),
      );
    }
  };
}

class GetDefaultHouseAction {
  final DefaultHouse _defaultHouse;
  DefaultHouse get defaultHouse => this._defaultHouse;
  GetDefaultHouseAction(this._defaultHouse);
}

////////////////////////////////////////////
/// Rooms
////////////////////////////////////////////

ThunkAction<AppState> createNewRoom(context, String roomName) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var houseID = sharedPreferences.getString("houseID");

    var jsonResponse;

    Map data = {
      'name': roomName,
      'farmId': houseID,
      'image': 'https://cdn.vuetifyjs.com/images/cards/sunshine.jpg'
    };

    var response = await http.post(UrlProvider.createNewRoom,
        headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data);

    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      final newRoom = Rooms(
          id: jsonResponse["id"], name: jsonResponse["name"], devices: []);

      final newRoomBoxs = ApplianceBox(
        title: jsonResponse["name"],
        boxInfo: "0 Thiết bị",
        roomId: jsonResponse["id"],
      );

      store.state.defaultHouse.rooms.add(newRoom);
      store.state.defaultHouse.roomBoxs.add(newRoomBoxs);
      store.dispatch(GetDefaultHouseAction(store.state.defaultHouse));
      Navigator.pop(context);
    } else {
      print(response.body);
    }
  };
}

ThunkAction<AppState> addDevice(context, String deviceId, String roomId) {
  Map data = {
    'deviceId': deviceId,
    'cropId': roomId,
  };

  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var jsonResponse;

    var response = await http.post(UrlProvider.addDevice,
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
