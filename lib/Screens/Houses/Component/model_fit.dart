import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartizen/Models/houses.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Screens/Home/Home.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/utils/app_color.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({Key key, @required this.housesModel}) : super(key: key);

  final HousesModel housesModel;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              'Chỉnh sửa',
              style: AppColors.listTitleDefaultTextStyle,
            ),
            leading: Icon(Icons.edit, color: Colors.white, size: 25),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Chọn', style: AppColors.listTitleDefaultTextStyle),
            leading: Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 25,
            ),
            onTap: () => selectHouseDefault(context, housesModel),
          ),
          ListTile(
            title: Text(
              'Xóa',
              style: AppColors.listTitleDefaultTextStyle,
            ),
            leading: Icon(
              Icons.delete,
              color: Colors.white,
              size: 25,
            ),
            onTap: () => deleteHouse(context, housesModel),
          )
        ],
      ),
    ));
  }

  selectHouseDefault(context, housesModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("houseId", housesModel.toJson()["id"]);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
        ModalRoute.withName('/Home'));
  }

  deleteHouse(context, housesModel) async {
    final store = StoreProvider.of<AppState>(context);

    await store
        .dispatch(deleteHouseAction(context, housesModel.toJson()["id"]));
    Navigator.of(context).pop();
  }
}
