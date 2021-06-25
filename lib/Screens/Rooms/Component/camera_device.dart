import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:smartizen/Components/video_player.dart';
import 'package:smartizen/Provider/url_provider.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/utils/app_color.dart';
import 'dart:async';

// ignore: must_be_immutable
class CameraDevice extends StatefulWidget {
  String deviceId;
  String roomId;
  String description;
  String activeId;
  var functions;
  CameraDevice(
      {this.deviceId,
      this.roomId,
      this.description,
      this.activeId,
      this.functions});

  @override
  _CameraDeviceState createState() => _CameraDeviceState();
}

class _CameraDeviceState extends State<CameraDevice> {
  bool _isLoading = false;
  bool _turnOn = false;
  Timer _timer;
  Map<String, dynamic> deviceData;

  fetchCurrentDevice(store, String deviceId) async {
    await store.dispatch(getCurrentDevice(context, deviceId));

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        onInit: (store) {
          print("\n\ncurrent device " + widget.deviceId + "\n\n");
          fetchCurrentDevice(store, widget.deviceId);
          getSecurityStatus();
        },
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : StaggeredGridView.countBuilder(
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.extent(
                            state.currentDevice.functions[index].command != null
                                ? 1
                                : 2,
                            state.currentDevice.functions[index].command != null
                                ? 150
                                : 350);
                      },
                      itemCount: widget.functions.length,
                      itemBuilder: (context, index) => state
                                  .currentDevice.functions[index].command !=
                              null
                          ? GestureDetector(
                              onTap: () {
                                if (state.currentDevice.functions[index]
                                        .command !=
                                    null) {
                                  // check status
                                  if (_turnOn) {
                                    turnLamp(0);
                                  } else {
                                    turnLamp(1);
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.whiteOpacityColor,
                                    borderRadius: BorderRadius.circular(27)),
                                child: Container(
                                  decoration: _turnOn
                                      ? BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Color(0xff5fe686)
                                                  .withOpacity(0.26),
                                              Color(0xff262d2e)
                                                  .withOpacity(0.23)
                                            ],
                                            radius: 0.72,
                                            center: Alignment(0, 0),
                                          ),
                                          border: Border.all(
                                              width: 4,
                                              color: const Color(0xff5fe686)),
                                          borderRadius:
                                              BorderRadius.circular(27),
                                          boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 3),
                                                  blurRadius: 6,
                                                  color: Color(0xff000000)
                                                      .withOpacity(0.16))
                                            ])
                                      : null,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        widget.functions[index].name,
                                        style: TextStyle(
                                            fontFamily: "SF Rounded",
                                            fontSize: 21,
                                            color:
                                                Colors.white.withOpacity(0.7)),
                                      ),
                                      Container(
                                          child: Text(
                                        _turnOn ? "Bật" : "Tắt",
                                        style: TextStyle(
                                            fontFamily: "SF Rounded",
                                            fontSize: 30,
                                            color:
                                                Colors.white.withOpacity(0.14)),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: AppColors.whiteOpacityColor,
                                  borderRadius: BorderRadius.circular(27)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  // title
                                  Text(
                                    widget.functions[index].name,
                                    style: TextStyle(
                                        fontFamily: "SF Rounded",
                                        fontSize: 21,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                  // video
                                  Expanded(
                                    child: VideoPlayerApp(
                                        deviceId: widget.deviceId),
                                  ),
                                ],
                              ),
                            )));
        });
  }

  getSecurityStatus() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getSwitchStatus() async {
        var response = await http.get(UrlProvider.turnSecurity);
        var jsonResponse = json.decode(response.body);
        if (jsonResponse["reportMode"]) {
          setState(() {
            _turnOn = true;
          });
        } else {
          setState(() {
            _turnOn = false;
          });
        }
      }

      getSwitchStatus();
    });
  }

  turnLamp(int control) async {
    Map data = {'control': '$control'};

    var response = await http.post(UrlProvider.turnSecurity, body: data);
    if (response.statusCode == 201) {
    } else {
      print("turnSecurity");
      print(response.body);
    }
  }
}
