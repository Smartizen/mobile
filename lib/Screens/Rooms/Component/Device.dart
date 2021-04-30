import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:smartizen/Models/roomDetail.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Screens/Rooms/Component/DeviceDetails.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';

//ignore: must_be_immutable
class Device extends StatefulWidget {
  String deviceId;
  String roomId;
  String description;
  var functions;
  Device({this.deviceId, this.roomId, this.description, this.functions});
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  bool _isLoading = true;

  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  fetchCurrentDevice() async {
    final store = StoreProvider.of<AppState>(context);
    await store.dispatch(getCurrentDevice(context, widget.deviceId));
    setState(() {
      _isLoading = false;
    });
  }

  Future getSensorData() async {
    Map<String, dynamic> jsonResponse;
    Map data = {'sensor': "1"};
    var response =
        await http.post(DotEnv().env['IBM_CLOUD'] + "/sensorData", body: data);
    if (response.statusCode == 201) {
      jsonResponse = jsonDecode(response.body);
    }
    print("jsonResponse ${jsonResponse['data']}");
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
            fetchCurrentDevice();
          },
          converter: (store) => store.state,
          builder: (context, state) {
            return Container(
                decoration: BoxDecoration(
                  color: const Color(0xff202227),
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        widget.deviceId,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(18, 20, 18, 20),
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Expanded(
                                    child: StaggeredGridView.countBuilder(
                                    physics: BouncingScrollPhysics(),
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    staggeredTileBuilder: (index) {
                                      return StaggeredTile.extent(1, 150);
                                    },
                                    itemCount:
                                        state.currentDevice.functions.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.03),
                                            borderRadius:
                                                BorderRadius.circular(27)),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                state.currentDevice
                                                    .functions[index].name,
                                                style: TextStyle(
                                                    fontFamily: "SF Rounded",
                                                    fontSize: 21,
                                                    color: Colors.white
                                                        .withOpacity(0.7)),
                                              ),
                                              Container(
                                                child: StreamBuilder(
                                                    stream: Stream.periodic(
                                                            Duration(
                                                                seconds: 15))
                                                        .asyncMap((event) =>
                                                            getSensorData()),
                                                    builder:
                                                        (context, snapshot) {
                                                      return Text(
                                                        "15" + '°C',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "SF Rounded",
                                                            fontSize: 30,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.14)),
                                                      );
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )))),

                    // Expanded(child: DeviceDetails()),
                  ],
                ));
          }),
    );
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
            if (_text == 'Turn on the lamp' || _text == "Bật đèn lên") {
              _text = '';
              turnLamp("1");
            }
            if (_text == 'Turn off the lamp' || _text == "Tắt đèn đi") {
              _text = '';
              turnLamp("0");
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  turnLamp(String control) async {
    var jsonResponse;
    Map data = {'control': control};
    var response =
        await http.post(DotEnv().env['IBM_CLOUD'] + "/led", body: data);
    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print('Response : ${response.body}');
    }
    print(jsonResponse);
  }
}
