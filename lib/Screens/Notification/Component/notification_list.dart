import 'package:flutter/material.dart';
import 'package:smartizen/utils/app_color.dart';

// ignore: must_be_immutable
class NotificationList extends StatefulWidget {
  String id;
  String title;
  String body;
  String createdAt;
  NotificationList({
    this.id,
    this.title,
    this.body,
    this.createdAt,
  });
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  String day;
  String month;
  String hour;
  String minute;

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.parse(widget.createdAt);
    setState(() {
      day = date.day.toString();
      month = date.month.toString();
      hour = date.hour.toString();
      minute = date.minute.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 85,
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.white.withOpacity(0.28)),
          borderRadius: BorderRadius.circular(25)),
      child: Row(children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 12),
          child: CircleAvatar(
              radius: 30.0,
              child: Text(
                "N",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              backgroundColor: Colors.grey),
        ),
        Container(
          width: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, //change here don't //worked
                children: [
                  Text(
                    widget.body,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "SF Rounded",
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    day + ' thg ' + month + ' lúc ' + hour + ':' + minute,
                    style: TextStyle(
                        fontFamily: "SF Rounded",
                        fontSize: 16,
                        color: AppColors.iconColor),
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
