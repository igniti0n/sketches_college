import 'package:flutter/material.dart';
import '../../contants.dart';
import 'widgets/animation_preview.dart';
import 'widgets/settings_menu.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: medium,
      body: SettingsMenu(),

      // Flexible(
      //   flex: 2,
      //   child: AnimationPreview(),
      // )
    );
  }
}
