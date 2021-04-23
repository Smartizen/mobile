import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartizen/Models/houses.dart';
import 'package:smartizen/Screens/Home/Home.dart';

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
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Sellect'),
            leading: Icon(Icons.check_circle_outline),
            onTap: () => selectHouseDefault(context, housesModel),
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    ));
  }

  selectHouseDefault(context, housesModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("houseID", housesModel.toJson()["id"]);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
        ModalRoute.withName('/Home'));
  }
}
