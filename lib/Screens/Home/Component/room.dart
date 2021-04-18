import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smartizen/Redux/app_state.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  // List<ApplianceBox> items = [
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
              staggeredTiles: state.defaultHouse.roomBoxs
                  .map((item) => StaggeredTile.extent(1, 170))
                  .toList(),
            ),
          );
        });
  }
}
