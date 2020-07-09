import 'package:flutter/material.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';

class TextIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;

  TextIcon(
      {@required this.icon,
      this.iconSize,
      this.iconColor = Colors.white,
      @required this.text,
      this.textSize,
      this.textColor = Colors.white,
      this.textWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: iconSize == null ? FontSize.s18 : iconSize,
          color: iconColor,
        ),
        SizedBox(width: Sizes.s5),
        Text(
          "$text",
          style: TextStyle(
            fontSize: textSize == null ? FontSize.s15 : textSize,
            color: textColor,
            fontWeight: textWeight,
          ),
        )
      ],
    );
  }
}
