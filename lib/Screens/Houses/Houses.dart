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
      appBar: AppBar(
        backgroundColor: const Color(0xff202227),
        title: Text("Housing management"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Expanded(child: HousesBody()),
        ],
      ),
    );
  }
}
