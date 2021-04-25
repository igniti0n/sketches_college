import 'package:flutter/material.dart';

class SketchButton extends StatelessWidget {
  final double maxWidth;
  final IconData icon;
  final Color splashColor;
  final Color? iconColor;
  final Function() onTap;
  const SketchButton({
    Key? key,
    required this.maxWidth,
    required this.onTap,
    required this.icon,
    required this.splashColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.grey[700]!.withAlpha(200),
          shape: BoxShape.circle,
        ),
        child: Material(
          elevation: 0,
          borderOnForeground: false,
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Future.delayed(Duration(milliseconds: 150), onTap),
            splashColor: splashColor,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Icon(
              icon,
              size: maxWidth / 4,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
