import 'package:flutter/material.dart';
import 'package:paint_app/contants.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';

class SettingsMenuButton extends StatelessWidget {
  final String text;
  final Color splashColor;
  final Function() onTap;
  const SettingsMenuButton({
    Key? key,
    required this.onTap,
    required this.text,
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
              child: AutoSizeText(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
