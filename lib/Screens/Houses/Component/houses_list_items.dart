import 'package:flutter/material.dart';
import 'package:smartizen/Models/houses.dart';

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
          onTap: () => print(housesModel)),
    );
  }
}
