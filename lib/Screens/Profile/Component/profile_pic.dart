import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/utils/app_color.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 130,
                width: 130,
                child: Stack(
                  fit: StackFit.expand,
                  // overflow: Overflow.visible,
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      child: Text(
                          state.user["firstname"][0] +
                              state.user["lastname"][0],
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.grey,
                      // backgroundImage: NetworkImage(
                      //     "https://avatars.githubusercontent.com/u/77471619"),
                      // backgroundColor: Colors.transparent,
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
                          color: AppColors.whiteOpacityColor,
                          onPressed: () {},
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.fontColor,
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.user["lastname"],
                          style: TextStyle(
                              fontFamily: "SF Rounded",
                              fontSize: 32,
                              color: Colors.white),
                        ),
                        Text(
                          state.user["email"],
                          style: TextStyle(
                              fontFamily: "SF Rounded",
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.6)),
                        ),
                      ]))
            ],
          );
        });
  }
}
