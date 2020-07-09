import 'package:flutter/material.dart';
import 'ScreenSizes.dart';

class ThemeColor {
  final Color fontColor = Colors.white;
  final Color backgroundColor = Color(0xff17223b);
  final Color darkShadeColor = Color(0xff111a2d);

  TextStyle white() {
    return TextStyle(color: fontColor);
  }

  TextStyle imageTitle() {
    return TextStyle(
      color: fontColor,
      fontSize: Sizes.s16,
    );
  }

  TextStyle lightGrey() {
    return TextStyle(color: Colors.grey[350]);
  }

  TextStyle subtitleWrapper() {
    return TextStyle(color: Colors.grey[350], fontSize: FontSize.s12);
  }
}
