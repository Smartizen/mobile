import 'package:flutter/material.dart';
import 'package:smartizen/Screens/Profile/Component/body.dart';

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
      backgroundColor: const Color(0xff202227),
      appBar: AppBar(
        backgroundColor: const Color(0xff202227),
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
