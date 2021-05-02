import 'package:flutter/material.dart';
import '../../contants.dart';
import '../../core/widgets/settings_menu_button.dart';

SimpleDialog loadingView(BuildContext context) {
  return SimpleDialog(
    backgroundColor: overlayBackground,
    title: Text("Processing..."),
    children: [
      CircularProgressIndicator(),
    ],
  );
}

SimpleDialog outcomeView(
    BuildContext context, String errorMessage, Function() onTap) {
  return SimpleDialog(
    backgroundColor: overlayBackground,
    title: Text(errorMessage),
    children: [
      SettingsMenuButton(
        onTap: onTap,
        splashColor: purpleBar,
        text: 'Done',
      ),
    ],
  );
}
