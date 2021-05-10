import 'package:flutter/material.dart';
import 'package:smartizen/Screens/Profile/Component/body.dart';
import 'package:smartizen/utils/app_color.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroud,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroud,
        title: Text("Profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50),
          Expanded(child: ProfileBody()),
        ],
      ),
    );
  }
}
