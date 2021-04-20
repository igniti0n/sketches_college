import 'package:flutter/material.dart';
import 'package:paint_app/contants.dart';
import 'package:paint_app/view/settings_screen/widgets/settings_menu_button.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SettingsMenuButton(
          onTap: () {},
          text: "Prewiev animation",
          splashColor: purpleBar,
        ),
        SettingsMenuButton(
          onTap: () {},
          text: "Change background color",
          splashColor: purpleBar,
        ),
        SettingsMenuButton(
          onTap: () {},
          text: "Export sketch",
          splashColor: purpleBar,
        ),
        SettingsMenuButton(
          onTap: () {},
          text: "Back to drawing",
          splashColor: purpleBar,
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
