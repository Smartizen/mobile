import 'package:meta/meta.dart';
import 'package:smartizen/Models/default_house.dart';
import 'package:smartizen/Models/roomDetail.dart';
import 'package:smartizen/Models/houses.dart';

@immutable
class AppState {
  final dynamic user;
  final List<HousesModel> houses;
  final DefaultHouse defaultHouse;
  final RoomDetail roomDetail;

  AppState(
      {@required this.user,
      @required this.houses,
      @required this.defaultHouse,
      @required this.roomDetail});

  factory AppState.initial() {
    return AppState(
        user: null, houses: [], defaultHouse: null, roomDetail: null);
  }
}
