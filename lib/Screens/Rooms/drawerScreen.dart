import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Components/alert.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'dart:convert';

//ignore: must_be_immutable
class DrawerScreen extends StatefulWidget {
  String roomId;
  DrawerScreen({this.roomId});
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
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
                      store.dispatch(
                          addDevice(context, deviceId, widget.roomId));
                    },
                  )
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            SizedBox(height: 90),
            GestureDetector(
              onTap: () => {_showModalBottomSheet(context)},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Thêm thiết bị",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17))
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {print("Chinh sua phong")},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Chỉnh sửa phòng",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17))
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {
                showDialog(
                  context: context,
                  // TODO
                  builder: (_) => FunkyOverlay(),
                )
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Xóa phòng",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17))
                  ],
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
