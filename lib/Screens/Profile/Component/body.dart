import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartizen/Screens/Houses/Houses.dart';
import 'package:smartizen/Screens/SignInScreen.dart';
import 'package:smartizen/Screens/UpdateProfile/UpdateProfile.dart';

import './profile_menu.dart';
import './profile_pic.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Quản lý nhà",
            icon: Icons.house_outlined,
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => Houses()),
              );
            },
          ),
          ProfileMenu(
            text: "Cập nhật trang cá nhân",
            icon: Icons.settings,
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => UpdateProfile()),
              );
            },
          ),
          ProfileMenu(
            text: "Trợ giúp",
            // icon: "assets/icons/Question mark.svg",
            icon: Icons.help_outline_outlined,
            press: () {},
          ),
          ProfileMenu(
            text: "Đăng xuất",
            icon: Icons.logout,
            press: () async {
              sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignInScreen()),
                  ModalRoute.withName('/SignIn'));
            },
          ),
        ],
      ),
    );
  }
}
