import 'package:flutter/material.dart';
import 'package:smartizen/utils/app_color.dart';

class NotificationBox extends StatefulWidget {
  @override
  _NotificationBoxState createState() => _NotificationBoxState();
}

class _NotificationBoxState extends State<NotificationBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroud,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroud,
        title: Text("Thông báo"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
