import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:smartizen/Screens/Rooms/Component/DeviceDetails.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';

//ignore: must_be_immutable
class Device extends StatefulWidget {
  String deviceName;
  String roomId;
  Device({this.deviceName, this.roomId});
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
      body: Container(
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
                widget.roomId,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Expanded(child: DeviceDetails()),
          ],
        ),
      ),
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
