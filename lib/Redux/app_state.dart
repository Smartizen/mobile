import 'package:meta/meta.dart';
import 'package:smartizen/Models/houses.dart';

@immutable
class AppState {
  final dynamic user;
  final List<HousesModel> houses;

  AppState({@required this.user, @required this.houses});

  factory AppState.initial() {
    return AppState(user: null, houses: []);
  }
}
