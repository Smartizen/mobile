import 'package:flutter/material.dart';
import 'package:smartizen/Screens/Houses/Component/body.dart';
import 'package:smartizen/utils/app_color.dart';

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
      backgroundColor: AppColors.primaryBackgroud,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroud,
        title: Text("Quản lý nhà"),
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
