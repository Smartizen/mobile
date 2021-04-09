import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartizen/Models/houses.dart';
import 'package:smartizen/Screens/Home.dart';

class HouseListItem extends StatelessWidget {
  const HouseListItem({
    Key key,
    @required this.itemIndex,
    @required this.housesModel,
  }) : super(key: key);

  final int itemIndex;
  final HousesModel housesModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
          title: Text(
            housesModel.name,
            style:
                TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            housesModel.location,
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
          ),
          isThreeLine: true,
          onTap: () => selectHouseDefault(context, housesModel)),
    );
  }

  selectHouseDefault(context, housesModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("houseID", housesModel.toJson()["id"]);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
        ModalRoute.withName('/Home'));
  }
}
