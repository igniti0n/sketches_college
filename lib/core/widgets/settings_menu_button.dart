import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsMenuButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Color? contentColor;
  final Color splashColor;
  final Function() onTap;
  const SettingsMenuButton({
    Key? key,
    required this.onTap,
    this.icon,
    this.text,
    this.contentColor,
    required this.splashColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: double.infinity,
        // height: double.infinity,
        margin: EdgeInsets.all(2),

        // decoration: BoxDecoration(
        //   color: light,
        // ),
        child: Material(
          elevation: 0,
          borderOnForeground: false,
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Future.delayed(Duration(milliseconds: 240), onTap),
            splashColor: splashColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: this.text == null
                  ? FaIcon(icon)
                  : Text(
                      text!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: contentColor),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
