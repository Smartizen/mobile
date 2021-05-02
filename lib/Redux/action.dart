// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:smartizen/Components/application_box.dart';
import 'package:smartizen/Models/defaultHouse.dart';
import 'package:smartizen/Models/members.dart';
import 'package:smartizen/Models/roomDetail.dart';
import 'package:smartizen/Models/houses.dart';
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
      print("singin");
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
      print("singUp");
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
      print("auth");
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
    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse["data"];
      sharedPreferences.setString("houseId", jsonResponse["id"]);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => Houses()),
      );
      // TODO add to House array
    } else {
      print("createHouse");
      print(response.body);
    }
  };
}

ThunkAction<AppState> deleteHouseAction(context, String houseId) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");

    var response =
        await http.delete(UrlProvider.getHouseDetail(houseId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      store.state.houses.removeWhere((houses) => houses.id == houseId);
      store.dispatch(GetHousesAction(store.state.houses));
    } else {
      print("deleteHouseAction");
      print(response.body);
    }
  };
}

ThunkAction<AppState> getHousesData(context, bool isSetHouse) {
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
        if (jsonResponse["houses"].length == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => AddHouse()),
          );
        } else {
          if (isSetHouse) {
            var isHaveHouse = sharedPreferences.containsKey('houseId');
            if (!isHaveHouse)
              sharedPreferences.setString(
                  "houseId", jsonResponse['houses'][0]["id"]);
          } else {
            store.dispatch(
                GetHousesAction(_loadHousesModel(jsonResponse["houses"])));
          }
        }
      }
    } else {
      print("getHousesData");
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
    var isHaveHouse = sharedPreferences.containsKey('houseId');
    if (isHaveHouse) {
      var houseId = sharedPreferences.getString("houseId");
      var jsonResponse;

      var response =
          await http.get(UrlProvider.getHouseDetail(houseId), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        jsonResponse = jsonResponse["house"];

        if (jsonResponse != null) {
          // final members = jsonResponse["members"] as List;
          final rooms = jsonResponse["rooms"] as List;
          final _defaultHouse = DefaultHouse(
            id: jsonResponse["id"],
            name: jsonResponse["name"],
            image: jsonResponse["image"],
            lat: jsonResponse["lat"],
            long: jsonResponse["long"],
            rooms: rooms.map((room) => Rooms.fromJson(room)).toList(),
          );
          store.dispatch(GetDefaultHouseAction(_defaultHouse));
        } else {
          sharedPreferences.remove("houseId");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => AddHouse()),
          );
        }
      } else {
        print("getDefaultHousesData");
        print(response.body);
      }
    } else {
      sharedPreferences.remove("houseId");
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
    var houseId = sharedPreferences.getString("houseId");

    var jsonResponse;

    Map data = {
      'name': roomName,
      'houseId': houseId,
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
          id: jsonResponse["id"], name: jsonResponse["name"], actives: []);

      store.state.defaultHouse.rooms.add(newRoom);
      store.dispatch(GetDefaultHouseAction(store.state.defaultHouse));
      Navigator.pop(context);
    } else {
      print("createNewRoom");
      print(response.body);
    }
  };
}

ThunkAction<AppState> getRoomDetail(context, String roomId) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var jsonResponse;

    var response = await http.get(UrlProvider.getRoomDetail(roomId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse["data"];

      // convert list type
      final roomDetail = RoomDetail(
          devices: jsonResponse["devices"]
              .map<Device>((device) => Device.fromJson(device))
              .toList());

      store.dispatch(GetRoomDetailAction(roomDetail));
    } else {
      print("getRoomDetailAction");
      print(response.body);
    }
  };
}

ThunkAction<AppState> deleteRoomAction(context, String roomId) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");

    var response =
        await http.delete(UrlProvider.getRoomDetail(roomId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      // store.state.houses.removeWhere((houses) => houses.id == houseId);
      // store.dispatch(GetHousesAction(store.state.houses));
    } else {
      print("deleteRoomAction");
      print(response.body);
    }
  };
}

class GetRoomDetailAction {
  final RoomDetail _roomDetail;
  RoomDetail get roomDetail => this._roomDetail;
  GetRoomDetailAction(this._roomDetail);
}

////////////////////////////////////////////
/// Device
////////////////////////////////////////////

ThunkAction<AppState> addDevice(context, String deviceId, String roomId) {
  Map data = {
    'deviceId': deviceId,
    'roomId': roomId,
  };

  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");

    var response = await http.post(UrlProvider.addDevice,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data);
    if (response.statusCode == 201) {
      int roomIndex = store.state.defaultHouse.rooms
          .indexWhere((room) => room.id == roomId);

      store.state.defaultHouse.rooms[roomIndex].actives
          .add(Actives(deviceId: deviceId));

      await store.dispatch(GetDefaultHouseAction(store.state.defaultHouse));

      Navigator.pop(context);
    } else {
      print("addDevice");
      print(response.body);
    }
  };
}

ThunkAction<AppState> getCurrentDevice(context, String deviceId) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var jsonResponse;

    var response =
        await http.get(UrlProvider.getDeviceDetail(deviceId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse["data"];

      // convert list type
      final device = Device(
          id: jsonResponse["id"],
          deviceId: jsonResponse["deviceId"],
          description: jsonResponse["description"],
          functions: jsonResponse["functions"]
              .map<Functions>((function) => Functions.fromJson(function))
              .toList());

      store.dispatch(GetCurrentDeviceAction(device));
    } else {
      print("getCurrentDeviceAction");
      print(response.body);
    }
  };
}

class GetCurrentDeviceAction {
  final Device _currentDevice;
  Device get currentDevice => this._currentDevice;
  GetCurrentDeviceAction(this._currentDevice);
}

////////////////////////////////////////////
/// Members
////////////////////////////////////////////

ThunkAction<AppState> addNewMember(context, String email) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var houseId = sharedPreferences.getString("houseId");

    var jsonResponse;

    Map data = {
      'email': email,
      'houseId': houseId,
    };

    var response = await http.post(UrlProvider.addNewMemberByEmail,
        headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data);

    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse["data"];
      final newMember = Member(
          id: jsonResponse["id"],
          firstname: jsonResponse["firstname"],
          lastname: jsonResponse["lastname"],
          email: jsonResponse["email"],
          role: jsonResponse["role"]);

      store.state.members.members.add(newMember);
      store.dispatch(GetMembersAction(store.state.members));
      Navigator.pop(context);
    } else {
      print("createNewRoom");
      print(response.body);
    }
  };
}

ThunkAction<AppState> deleteManageAction(context, String manageId) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");

    var response =
        await http.delete(UrlProvider.getAllMember(manageId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      store.state.members.members
          .removeWhere((member) => member.manageId == manageId);
      store.dispatch(GetMembersAction(store.state.members));
    } else {
      print("deleteMemberAction");
      print(response.body);
    }
  };
}

ThunkAction<AppState> getMembersOfHouse(context) {
  return (Store<AppState> store) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var houseId = sharedPreferences.getString("houseId");

    var jsonResponse;

    var response = await http.get(UrlProvider.getAllMember(houseId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      jsonResponse = jsonResponse["data"];

      // convert list type
      final members = Members(
          members: jsonResponse
              .map<Member>((member) => Member.fromJson(member))
              .toList());

      store.dispatch(GetMembersAction(members));
    } else {
      print("GetMembersAction");
      print(response.body);
    }
  };
}

class GetMembersAction {
  final Members _members;
  Members get members => this._members;
  GetMembersAction(this._members);
}
