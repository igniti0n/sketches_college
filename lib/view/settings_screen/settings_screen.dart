import 'package:flutter/material.dart';
import 'package:paint_app/contants.dart';
import 'package:paint_app/view/settings_screen/widgets/animation_preview.dart';
import 'package:paint_app/view/settings_screen/widgets/settings_menu.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: medium,
      body: Row(
        children: [
          Expanded(
            child: SettingsMenu(),
          ),
          Expanded(
            child: AnimationPreview(),
          )
        ],
      ),
    );
  }
}
