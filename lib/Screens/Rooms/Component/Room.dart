import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:smartizen/Components/RoomDetails.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';

//ignore: must_be_immutable
class Room extends StatefulWidget {
  String title;
  String roomId;
  Room({this.title, this.roomId});
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
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
      backgroundColor: const Color(0xff202227),
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
      appBar: AppBar(
        backgroundColor: const Color(0xff202227),
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: RoomDetails()),
        ],
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
