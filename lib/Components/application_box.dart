import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartizen/Screens/Rooms/Rooms.dart';
import 'package:smartizen/utils/app_color.dart';

//ignore: must_be_immutable
class ApplianceBox extends StatefulWidget {
  String title;
  SvgPicture image;
  String boxInfo;
  String roomId;
  ApplianceBox({this.title, this.image, this.boxInfo, this.roomId});
  @override
  _ApplianceBoxState createState() => _ApplianceBoxState();
}

class _ApplianceBoxState extends State<ApplianceBox> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    //
    bool svgProvided = widget.image == null ? false : true;
    //
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Rooms(title: widget.title, roomId: widget.roomId),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteOpacityColor,
              borderRadius: BorderRadius.circular(27)),
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xff5fe686).withOpacity(0.26),
                        Color(0xff262d2e).withOpacity(0.23)
                      ],
                      radius: 0.72,
                      center: Alignment(0, 0),
                    ),
                    border:
                        Border.all(width: 4, color: const Color(0xff5fe686)),
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                            color: Color(0xff000000).withOpacity(0.16))
                      ])
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: "SF Rounded",
                      fontSize: 21,
                      color: AppColors.fontColor),
                ),
                Visibility(
                  visible: widget.image == null ? false : true,
                  child: Center(
                      child: Container(
                    height: 100,
                    width: 100,
                    child: widget.image ?? null,
                  )),
                ),
                Text(
                  widget.boxInfo,
                  style: TextStyle(
                      fontFamily: "SF Rounded",
                      fontSize: 21,
                      color: Colors.white.withOpacity(0.14)),
                )
              ],
            ),
          ),
        ));
  }
}
