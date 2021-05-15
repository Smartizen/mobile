import 'package:flutter/material.dart';

class AppColors {
  static const primaryBackgroud = const Color(0xff202227);
  static const houseBoxColor = const Color(0xff5b5b5b);
  static Color deviceBoxColor = Colors.white.withOpacity(0.02);
  static Color whiteOpacityColor = Colors.white.withOpacity(0.03);
  static Color iconColor = Colors.white.withOpacity(0.25);
  static Color fontColor = Colors.white.withOpacity(0.7);
  static const footBarBackgroud = const Color(0xff353535);

  static TextStyle listTitleDefaultTextStyle = TextStyle(
      color: Colors.white70, fontSize: 20.0, fontWeight: FontWeight.w600);
  static TextStyle listTitleSelectedTextStyle = TextStyle(
      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600);

  static Color selectedColor = Color(0xFF4AC8EA);
  static Color drawerBackgroundColor = Color(0xFF272D34);
  static LinearGradient gradient = LinearGradient(
      begin: Alignment(0.5, 0),
      end: Alignment(0.5, 1),
      colors: [Color(0xff7afc79), Color(0xff3ccb97)]);
}
