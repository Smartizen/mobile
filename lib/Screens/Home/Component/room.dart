import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartizen/Components/application_box.dart';
import 'package:smartizen/Redux/app_state.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  // List<ApplianceBox> items = [
  //   ApplianceBox(title: "Bedroom", boxInfo: "2 Devices"),
  //   ApplianceBox(
  //     title: "LivingRoom",
  //     boxInfo: "7 Devices",
  //     image: SvgPicture.asset('assets/sofa.svg'),
  //   ),
  //   ApplianceBox(
  //     title: "Kitchen",
  //     boxInfo: "5 Devices",
  //     image: SvgPicture.asset("assets/fridge.svg"),
  //   ),
  //   ApplianceBox(title: "Bedroom", boxInfo: "2 Devices"),
  // ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.fromLTRB(18, 20, 18, 20),
            child: StaggeredGridView.count(
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: state.defaultHouse.roomBoxs,
              staggeredTiles: [
                StaggeredTile.extent(1, 150),
                StaggeredTile.extent(1, 220),
                StaggeredTile.extent(1, 220),
                StaggeredTile.extent(1, 150)
              ],
            ),
          );
        });
  }
}
