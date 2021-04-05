import 'package:flutter/material.dart';
import 'package:smartizen/Screens/Houses/Houses.dart';

import './profile_menu.dart';
import './profile_pic.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Housing management",
            icon: Icons.house_outlined,
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => Houses()),
              );
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: Icons.settings,
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            // icon: "assets/icons/Question mark.svg",
            icon: Icons.help_outline_outlined,
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icons.logout,
            press: () {},
          ),
        ],
      ),
    );
  }
}
