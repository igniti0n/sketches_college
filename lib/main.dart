import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:paint_app/core/navigation/router.dart';
import 'package:paint_app/data/repositories/drawings_repository_impl.dart';
import 'package:paint_app/data/repositories/sketches_repository_impl.dart';
import 'package:paint_app/view/home_screen/home_screen.dart';
import 'package:paint_app/view/home_screen/sketches_bloc/sketches_bloc.dart';
import 'package:paint_app/view/overlay_screens/bloc/overlay_bloc.dart';
import 'package:paint_app/view/painter_screen/drawing_bloc/drawing_bloc.dart';
import 'package:paint_app/view/settings_screen/settings_bloc/settings_bloc.dart';

import 'view/painter_screen/widgets/paint_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);
  runApp(MyApp());
}

final SketchesRepositoryImpl _sketchesRepositoryImpl = SketchesRepositoryImpl();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY),
        builder: (context, snapshot) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<DrawingBloc>(
                create: (_) => DrawingBloc(DrawingsRepositoryImpl()),
              ),
              BlocProvider<SketchesBloc>(
                create: (_) => SketchesBloc(_sketchesRepositoryImpl),
              ),
              BlocProvider<OverlayBloc>(
                create: (_) => OverlayBloc(_sketchesRepositoryImpl),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              onGenerateRoute: onGenerateRoute,
            ),
          );
        });
  }
}
