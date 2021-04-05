import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          width: 130,
          child: Stack(
            fit: StackFit.expand,
            // overflow: Overflow.visible,
            children: [
              // TODO : fixed avatar
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/77471619"),
                backgroundColor: Colors.transparent,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.white),
                    ),
                    color: Colors.white.withOpacity(0.03),
                    onPressed: () {},
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white.withOpacity(0.7),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        state.user["lastname"],
                        style: TextStyle(
                            fontFamily: "SF Rounded",
                            fontSize: 32,
                            color: Colors.white),
                      ),
                    ]);
              }),
        )
      ],
    );
  }
}
