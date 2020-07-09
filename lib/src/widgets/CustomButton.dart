import 'package:flutter/material.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';
import 'package:unsplash_bloc/src/utils/Theme.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  CustomButton({@required this.icon, @required this.onTap});

  final color = ThemeColor();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color.darkShadeColor,
            borderRadius: BorderRadius.all(
              Radius.circular(Sizes.s10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.8),
                blurRadius: 3.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ]),
        alignment: Alignment.center,
        height: Sizes.s40,
        width: Sizes.s60,
        child: Icon(
          icon,
          size: FontSize.s20,
        ),
      ),
    );
  }
}
