import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Components/alert.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Screens/Home/Home.dart';
import 'package:smartizen/Screens/Rooms/Component/Device.dart';
import 'package:smartizen/Screens/Rooms/Component/transformer_form.dart';
import 'package:smartizen/utils/app_color.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'package:barcode_scan/platform_wrapper.dart';
import 'package:smartizen/Redux/action.dart';
import 'dart:convert';

//ignore: must_be_immutable
class RoomsScreen extends StatefulWidget {
  String title;
  String roomId;
  RoomsScreen({this.title, this.roomId});

  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _showModalBottomSheet(context) {
    final store = StoreProvider.of<AppState>(context);

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          String deviceName = "";
          String deviceId = "";
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    elevation: 5.0,
                    child: Text("Quét QR code"),
                    onPressed: () async {
                      var codeSanner =
                          await BarcodeScanner.scan(); //barcode scnner
                      var jsonResponse = json.decode(codeSanner.rawContent);

                      mystate(() {
                        deviceName = jsonResponse["deviceName"];
                        deviceId = jsonResponse["deviceId"];
                      });
                    },
                  ),
                  deviceName.length > 0
                      ? Container(
                          width: 250,
                          child: Image.asset(
                            'assets/device.png',
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            var codeSanner =
                                await BarcodeScanner.scan(); //barcode scnner
                            var jsonResponse =
                                json.decode(codeSanner.rawContent);

                            mystate(() {
                              deviceName = jsonResponse["deviceName"];
                              deviceId = jsonResponse["deviceId"];
                            });
                          },
                          child: Image.asset(
                            'assets/scanQr.jpg',
                          ),
                        ),
                  new Text(
                    deviceName.length > 0
                        ? "Xác nhận kết nối : " + deviceName
                        : "",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  OutlineButton(
                    child: Text(
                      "Kết nối",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    highlightedBorderColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      addDeviceByQr(context, deviceId);
                    },
                  )
                ],
              ),
            );
          });
        });
  }

  addDeviceByQr(context, deviceId) async {
    final store = StoreProvider.of<AppState>(context);
    await store.dispatch(addDevice(context, deviceId, widget.roomId));
    await store.dispatch(getRoomDetail(context, widget.roomId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00000000),
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "Cài đặt",
                style: AppColors.listTitleDefaultTextStyle,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ),
              title: Text(
                'Thêm thiết bị',
                style: AppColors.listTitleDefaultTextStyle,
              ),
              onTap: () => {_showModalBottomSheet(context)},
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.white, size: 25),
              title: Text(
                'Chỉnh sửa phòng',
                style: AppColors.listTitleDefaultTextStyle,
              ),
            ),
            ListTile(
              onTap: () => {
                showDialog(
                  context: context,
                  builder: (_) => FunkyOverlay(
                    title: "Bạn có đồng ý xóa phòng này không ?",
                    onPressed: () async {
                      final store = StoreProvider.of<AppState>(context);
                      await store
                          .dispatch(deleteRoomAction(context, widget.roomId));
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home()),
                          ModalRoute.withName('/Home'));
                    },
                  ),
                )
              },
              leading:
                  Icon(Icons.delete_outline, color: Colors.white, size: 25),
              title:
                  Text('Xóa phòng', style: AppColors.listTitleDefaultTextStyle),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroud,
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryBackgroud,
          ),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                return TransformerPageView(
                  scrollDirection: Axis.horizontal,
                  curve: Curves.easeInBack,
                  transformer: transformers[5], // transformers[5],
                  itemCount: state.roomDetail.devices.length,
                  itemBuilder: (context, index) {
                    final deviceId = state.roomDetail.devices[index].deviceId;
                    final activeId = state.roomDetail.devices[index].activeId;
                    final description =
                        state.roomDetail.devices[index].description;
                    final functions = state.roomDetail.devices[index].functions;

                    return Device(
                        activeId: activeId,
                        deviceId: deviceId,
                        description: description,
                        roomId: widget.roomId,
                        functions: functions);
                  },
                );
              })),
    );
  }
}
