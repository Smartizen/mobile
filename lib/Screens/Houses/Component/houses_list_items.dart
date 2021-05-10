import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smartizen/Models/houses.dart';
import 'package:smartizen/Screens/Houses/Component/model_fit.dart';
import 'package:smartizen/utils/app_color.dart';

class HouseListItem extends StatelessWidget {
  const HouseListItem({
    Key key,
    @required this.itemIndex,
    @required this.housesModel,
    @required this.defaultHouseId,
  }) : super(key: key);

  final int itemIndex;
  final HousesModel housesModel;
  final String defaultHouseId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.houseBoxColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
          title: Text(
            housesModel.name,
            style: TextStyle(
                color: AppColors.fontColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "",
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: defaultHouseId != housesModel.id
              ? null
              : Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                ),
          onTap: () => showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ModalFit(housesModel: this.housesModel),
              )),
    );
  }
}
