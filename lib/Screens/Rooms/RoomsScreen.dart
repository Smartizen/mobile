import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Screens/Rooms/Component/Device.dart';
import 'package:smartizen/Screens/Rooms/Component/transformer_form.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

//ignore: must_be_immutable
class RoomsScreen extends StatefulWidget {
  String title;
  String roomId;
  RoomsScreen({this.title, this.roomId});

  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(isDrawerOpen ? -0.5 : 0),
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: isDrawerOpen ? Colors.greenAccent[200] : Color(0xff202227),
        ),
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent[200],
            offset: const Offset(
              -15.0,
              15.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            xOffset = 0;
            yOffset = 0;
            scaleFactor = 1;
            isDrawerOpen = false;
          });
        },
        child: Scaffold(
          backgroundColor: const Color(0x00000000),
          appBar: AppBar(
            backgroundColor: const Color(0xff202227),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isDrawerOpen ? 40 : 0.0),
                topRight: Radius.circular(isDrawerOpen ? 40 : 0.0),
              ),
            ),
            title: Text(widget.title),
            leading: isDrawerOpen
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        xOffset = 0;
                        yOffset = 0;
                        scaleFactor = 1;
                        isDrawerOpen = false;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      xOffset = 230;
                      yOffset = 150;
                      scaleFactor = 0.6;
                      isDrawerOpen = true;
                    });
                  }),
            ],
          ),
          body: Container(
              decoration: BoxDecoration(
                color: const Color(0xff202227),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isDrawerOpen ? 40 : 0.0),
                    bottomRight: Radius.circular(isDrawerOpen ? 40 : 0.0)),
              ),
              // backgroundColor: const Color(0xff202227),
              child: StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, state) {
                    return TransformerPageView(
                      scrollDirection: Axis.vertical,
                      curve: Curves.easeInBack,
                      transformer: transformers[5], // transformers[5],
                      itemCount: state.roomDetail.devices.length,
                      itemBuilder: (context, index) {
                        final deviceId =
                            state.roomDetail.devices[index].deviceId;
                        final activeId =
                            state.roomDetail.devices[index].activeId;
                        final description =
                            state.roomDetail.devices[index].description;
                        final functions =
                            state.roomDetail.devices[index].functions;

                        return Device(
                            activeId: activeId,
                            deviceId: deviceId,
                            description: description,
                            roomId: widget.roomId,
                            functions: functions);
                      },
                    );
                  })),
        ),
      ),
    );
  }
}
