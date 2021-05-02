import 'package:flutter/material.dart';

//ignore: must_be_immutable
class Member extends StatefulWidget {
  String id;
  String firstname;
  String lastname;
  int role;
  Member({this.id, this.firstname, this.lastname, this.role});
  @override
  _MemberState createState() => _MemberState();
}

class _MemberState extends State<Member> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 85,
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.white.withOpacity(0.28)),
          borderRadius: BorderRadius.circular(25)),
      child: Row(children: [
        Image.asset('assets/profile_pic.png'),
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
                    widget.firstname == null
                        ? ""
                        : widget.firstname + widget.lastname,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "SF Rounded",
                        color: Colors.white),
                  ),
                  Chip(
                    labelPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    label: Text(
                      widget.role == 0 ? "Admin" : "Member",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // backgroundColor: const Colors(),
                    elevation: 6.0,
                    shadowColor: Colors.grey[60],
                    padding: EdgeInsets.all(6.0),
                  )
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
