import 'package:flutter/material.dart';

import '../../view/animation_preview_screen/animation_prewiev_screen.dart';
import '../../view/home_screen/home_screen.dart';
import '../../view/options_screen/settings_screen.dart';
import '../../view/painter_screen/paint_page.dart';

const String HOME_SCREEN_ROUTE = "/home_screen";
const String PAINT_SCREEN_ROUTE = "/paint_screen";
const String SETTINGS_SCREEN_ROUTE = "/settings_screen";
const String ANIMATION_PREVIEW_SCREEN_ROUTE = "/animation_prewview_screen";

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HOME_SCREEN_ROUTE:
      return _createRoute(
          HomeScreen()); // MaterialPageRoute(builder: (_) => HomeScreen());
    case PAINT_SCREEN_ROUTE:
      return _createRoute(
          PaintPage()); //MaterialPageRoute(builder: (_) => PaintPage());
    case SETTINGS_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (_) => OptionsScreen());
    case ANIMATION_PREVIEW_SCREEN_ROUTE:
      return _createRoute(
          AnimationPreviewScreen()); //MaterialPageRoute(builder: (_) => AnimationPreviewScreen());
    default:
      return _createRoute(
          HomeScreen()); //MaterialPageRoute(builder: (_) => HomeScreen());
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
