import 'package:flutter/material.dart';
import 'package:paint_app/view/home_screen/home_screen.dart';
import 'package:paint_app/view/painter_screen/paint_page.dart';

const String HOME_SCREEN_ROUTE = "/home_screen";
const String PAINT_SCREEN_ROUTE = "/paint_screen";

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HOME_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case PAINT_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (_) => PaintPage());
    default:
      return MaterialPageRoute(builder: (_) => HomeScreen());
  }
}
