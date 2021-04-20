import 'package:flutter/material.dart';
import 'package:paint_app/view/home_screen/home_screen.dart';
import 'package:paint_app/view/painter_screen/widgets/paint_page.dart';
import 'package:paint_app/view/settings_screen/settings_screen.dart';

const String HOME_SCREEN_ROUTE = "/home_screen";
const String PAINT_SCREEN_ROUTE = "/paint_screen";
const String SETTINGS_SCREEN_ROUTE = "/settings_screen";

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HOME_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case PAINT_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (_) => PaintPage());
    case SETTINGS_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (_) => SettingsScreen());
    default:
      return MaterialPageRoute(builder: (_) => HomeScreen());
  }
}
