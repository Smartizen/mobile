import 'package:flutter/material.dart';
import 'package:smartizen/Screens/Rooms/RoomsScreen.dart';
import 'package:smartizen/Screens/Rooms/drawerScreen.dart';

//ignore: must_be_immutable
class Rooms extends StatefulWidget {
  String title;
  // String roomId;
  Rooms({
    this.title,
    // this.roomId
  });

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          RoomsScreen(
            title: widget.title,
          )
        ],
      ),
    );
  }
}
