import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:smartizen/Components/video_player.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/utils/app_color.dart';

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
                        return StaggeredTile.extent(2, 350);
                      },
                      itemCount: widget.functions.length,
                      itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                                color: AppColors.whiteOpacityColor,
                                borderRadius: BorderRadius.circular(27)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  child:
                                      VideoPlayerApp(deviceId: widget.deviceId),
                                ),
                              ],
                            ),
                          )));
        });
  }
}
