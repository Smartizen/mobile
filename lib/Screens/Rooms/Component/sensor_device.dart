import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Provider/url_provider.dart';
import 'package:smartizen/utils/app_color.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:speech_to_text/speech_to_text.dart' as stt;

// ignore: must_be_immutable
class SensorDevice extends StatefulWidget {
  String deviceId;
  String roomId;
  String description;
  String activeId;
  var functions;
  SensorDevice(
      {this.deviceId,
      this.roomId,
      this.description,
      this.activeId,
      this.functions});
  @override
  _SensorDeviceState createState() => _SensorDeviceState();
}

class _SensorDeviceState extends State<SensorDevice> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  bool _isLoading = true;
  Map<String, dynamic> deviceData;
  IO.Socket socket;

  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    connectSocket();
  }

  fetchCurrentDevice(store, String deviceId) async {
    await store.dispatch(getCurrentDevice(context, deviceId));

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  void connectSocket() {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    socket = IO.io(UrlProvider.socketConnection, <String, dynamic>{
      "transports": ["websocket"],
      // "autoConnect": false,
    });
    socket.io
      ..disconnect()
      ..connect();
    socket.onConnect((data) {
      print("Connected");
      socket.on(widget.deviceId, (msg) {
        // socket.on("Gen2_1", (msg) {
        if (mounted) {
          print(msg["message"]);
          setState(() {
            deviceData = msg["message"];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0x00000000),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        body: StoreConnector<AppState, AppState>(
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
                          return StaggeredTile.extent(1, 150);
                        },
                        itemCount: state.currentDevice.functions.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            if (state.currentDevice.functions[index].command !=
                                null) {
                              // check status
                              if (deviceData[state.currentDevice
                                      .functions[index].description] ==
                                  1) {
                                turnLamp(0);
                                setState(() {
                                  deviceData[state.currentDevice
                                      .functions[index].description] = 0;
                                });
                              } else {
                                turnLamp(1);
                                setState(() {
                                  deviceData[state.currentDevice
                                      .functions[index].description] = 1;
                                });
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.whiteOpacityColor,
                                borderRadius: BorderRadius.circular(27)),
                            child: Container(
                              decoration: state.currentDevice.functions[index]
                                              .command !=
                                          null &&
                                      deviceData != null &&
                                      deviceData[state.currentDevice
                                              .functions[index].description] ==
                                          1
                                  ? BoxDecoration(
                                      gradient: RadialGradient(
                                        colors: [
                                          Color(0xff5fe686).withOpacity(0.26),
                                          Color(0xff262d2e).withOpacity(0.23)
                                        ],
                                        radius: 0.72,
                                        center: Alignment(0, 0),
                                      ),
                                      border: Border.all(
                                          width: 4,
                                          color: const Color(0xff5fe686)),
                                      borderRadius: BorderRadius.circular(27),
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
                                    state.currentDevice.functions[index].name,
                                    style: TextStyle(
                                        fontFamily: "SF Rounded",
                                        fontSize: 21,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                  Container(
                                      child: Text(
                                    deviceData == null
                                        ? "Loading..."
                                        : state.currentDevice.functions[index]
                                                    .command ==
                                                null
                                            ? deviceData[state
                                                    .currentDevice
                                                    .functions[index]
                                                    .description]
                                                .toString()
                                            : deviceData[state
                                                        .currentDevice
                                                        .functions[index]
                                                        .description] ==
                                                    1
                                                ? "Bật"
                                                : "Tắt",
                                    style: TextStyle(
                                        fontFamily: "SF Rounded",
                                        fontSize: 30,
                                        color: Colors.white.withOpacity(0.14)),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
          },
        ));
  }

  void _listen() async {
    print(_isListening);
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            if (_text == 'Bật công tắc' ||
                _text == "Bật công tắc lên" ||
                _text == "Bật đèn lên" ||
                _text == "Bật đèn") {
              _text = '';
              turnLamp(1);
            }
            if (_text == 'Tắt công tắc' ||
                _text == "Tắt công tắc đi" ||
                _text == "Tắt đèn đi" ||
                _text == "Tắt đèn") {
              _text = '';
              turnLamp(0);
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  turnLamp(int control) async {
    Map data = {
      'deviceId': widget.deviceId,
      'channel': 'control',
      'command': '{"control": $control}'
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");

    var response = await http.post(UrlProvider.controlDevice,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data);
    if (response.statusCode == 201) {
    } else {
      print("controlDevice");
      print(response.body);
    }
  }
}
