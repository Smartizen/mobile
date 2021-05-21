import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Components/alert.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Screens/Home/Home.dart';
import 'package:smartizen/Screens/Rooms/Component/camera_device.dart';
import 'package:smartizen/Screens/Rooms/Component/sensor_device.dart';
import 'package:smartizen/utils/app_color.dart';

//ignore: must_be_immutable
class Device extends StatefulWidget {
  String deviceId;
  String roomId;
  String description;
  String activeId;
  var functions;
  Device(
      {this.deviceId,
      this.roomId,
      this.description,
      this.activeId,
      this.functions});
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  Map<String, dynamic> deviceData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0x00000000),
        body: Container(
            decoration: BoxDecoration(
              color: AppColors.deviceBoxColor,
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.deviceId,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => FunkyOverlay(
                                title: "Bạn có đồng ý xóa thiết bị này không ?",
                                onPressed: () async {
                                  final store =
                                      StoreProvider.of<AppState>(context);
                                  await store.dispatch(
                                      removeDevice(context, widget.activeId));
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Home()),
                                      ModalRoute.withName('/Home'));
                                },
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(18, 20, 18, 20),
                        child: widget.description == 'sensor'
                            ? SensorDevice(
                                activeId: widget.activeId,
                                deviceId: widget.deviceId,
                                description: widget.description,
                                roomId: widget.roomId,
                                functions: widget.functions)
                            : CameraDevice(
                                activeId: widget.activeId,
                                deviceId: widget.deviceId,
                                description: widget.description,
                                roomId: widget.roomId,
                                functions: widget.functions))),
              ],
            )));
  }
}
