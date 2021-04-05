import 'package:flutter/material.dart';
import 'package:smartizen/Screens/Houses/Component/body.dart';

class Houses extends StatefulWidget {
  @override
  _HousesState createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202227),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 25, top: 30),
            child: Positioned(
                top: 20,
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Text(
                      "Housing management",
                      style: TextStyle(
                          fontFamily: "SF Rounded",
                          fontSize: 24,
                          color: Colors.white),
                    )
                  ],
                )),
          ),
          SizedBox(height: 10),
          Expanded(child: HousesBody()),
        ],
      ),
    );
  }
}
