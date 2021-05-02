import 'package:meta/meta.dart';
import 'package:smartizen/Models/defaultHouse.dart';
import 'package:smartizen/Models/members.dart';
import 'package:smartizen/Models/roomDetail.dart';
import 'package:smartizen/Models/houses.dart';

@immutable
class AppState {
  final dynamic user;
  final List<HousesModel> houses;
  final DefaultHouse defaultHouse;
  final RoomDetail roomDetail;
  final Device currentDevice;
  final Members members;

  AppState(
      {@required this.user,
      @required this.houses,
      @required this.defaultHouse,
      @required this.roomDetail,
      @required this.currentDevice,
      @required this.members});

  factory AppState.initial() {
    return AppState(
        user: null,
        houses: [],
        defaultHouse: null,
        roomDetail: null,
        currentDevice: null,
        members: null);
  }
}
