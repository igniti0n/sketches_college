import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final Color splashColor;
  final Function() onTap;
  const SettingsButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.splashColor,
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
            onTap: () => Future.delayed(Duration(milliseconds: 240), onTap),
            splashColor: splashColor,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Icon(
              icon,
            ),
          ),
        ),
      ),
    );
  }
}
