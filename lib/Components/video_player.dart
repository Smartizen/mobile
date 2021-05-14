import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:smartizen/Provider/url_provider.dart';

//ignore: must_be_immutable
class VideoPlayerApp extends StatefulWidget {
  String deviceId;
  VideoPlayerApp({this.deviceId});
  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  Key _key = GlobalKey<ScaffoldState>();

  String url;
  VlcPlayerController vlcPlayerController;
  bool isPlaying = true;
  bool isBuffering = true;
  String position = '';
  String duration = '';
  double sliderValue = 0.0;
  double startValue = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      url = UrlProvider.videoStreaming("smartizen_gen1", widget.deviceId);
    });
    vlcPlayerController = new VlcPlayerController(onInit: () {
      vlcPlayerController.play();
    });
    vlcPlayerController.addListener(() {
      if (!this.mounted) {
        return;
      }
      if (vlcPlayerController.initialized) {
        var Position = vlcPlayerController.position;
        var Duration = vlcPlayerController.duration;
        if (Duration.inHours == 0) {
          var startPosition = Position.toString().split('.')[0];
          var startDuration = Duration.toString().split('.')[0];
          position =
              '${startPosition.split(':')[1]}:${startPosition.split(':')[2]}';
          duration =
              '${startDuration.split(':')[1]};${startDuration.split(':')[2]}';
        } else {
          position = Position.toString().split('.')[0];
          duration = Duration.toString().split('.')[0];
        }
        sliderValue = vlcPlayerController.position.inSeconds.toDouble();

        switch (vlcPlayerController.playingState) {
          case PlayingState.PLAYING:
            setState(() {
              isBuffering = false;
            });
            break;
          case PlayingState.BUFFERING:
            setState(() {
              isBuffering = true;
            });
            break;

          case PlayingState.STOPPED:
            setState(() {
              isBuffering = false;
              isPlaying = false;
            });
            break;

          case PlayingState.PAUSED:
            setState(() {
              isPlaying = false;
              isBuffering = false;
            });
            break;

          case PlayingState.ERROR:
            setState(() {});
            print('Error cant play');
            break;

          default:
            setState(() {});
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    vlcPlayerController.dispose();
  }

  void playAndPause() {
    String state = vlcPlayerController.playingState.toString();

    if (state == 'PlayingState.PLAYING') {
      vlcPlayerController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      vlcPlayerController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 250,
                child: new VlcPlayer(
                  controller: vlcPlayerController,
                  aspectRatio: 16 / 9,
                  url: url,
                  isLocalMedia: false,
                  placeholder: Container(
                    height: 250.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
