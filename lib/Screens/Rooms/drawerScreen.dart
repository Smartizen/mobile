import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

List<Map> drawerItems = [
  {'icon': Icons.mail, 'title': 'Adoption'},
  {'icon': Icons.mail, 'title': 'Donation'},
  {'icon': Icons.mail, 'title': 'Add pet'},
  {'icon': Icons.favorite, 'title': 'Favorites'},
  {'icon': Icons.mail, 'title': 'Messages'},
  {'icon': Icons.mail, 'title': 'Profile'},
];

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: drawerItems
                .map((element) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            element['icon'],
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(element['title'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
