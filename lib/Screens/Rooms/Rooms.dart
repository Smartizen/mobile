import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Screens/Rooms/RoomsScreen.dart';
import 'package:smartizen/Screens/Rooms/drawerScreen.dart';
import 'package:smartizen/utils/app_color.dart';

//ignore: must_be_immutable
class Rooms extends StatefulWidget {
  String title;
  String roomId;
  Rooms({this.title, this.roomId});

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  bool _isLoading = true;

  fetchRoomDetail() async {
    final store = StoreProvider.of<AppState>(context);
    await store.dispatch(getRoomDetail(context, widget.roomId));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroud,
        body: Container(
            child: StoreConnector<AppState, AppState>(
                onInit: (store) {
                  fetchRoomDetail();
                },
                converter: (store) => store.state,
                builder: (context, state) {
                  return _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            // DrawerScreen(roomId: widget.roomId),
                            RoomsScreen(
                              title: widget.title,
                              roomId: widget.roomId,
                            )
                          ],
                        );
                })));
  }
}
