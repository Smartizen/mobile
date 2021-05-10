import 'package:flutter/material.dart';
import 'package:smartizen/utils/app_color.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: AppColors.whiteOpacityColor,
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.iconColor,
              size: 30,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                    fontFamily: "SF Rounded",
                    fontSize: 21,
                    color: AppColors.fontColor),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
