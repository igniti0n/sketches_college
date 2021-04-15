import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:paint_app/data/repositories/drawings_repository_impl.dart';
import 'package:paint_app/view/painter_screen/drawing_bloc/drawing_bloc.dart';
import 'package:paint_app/view/painter_screen/settings_bloc/settings_bloc.dart';

import 'view/painter_screen/paint_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY),
        builder: (context, snapshot) {
          return MaterialApp(
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
            home: MultiBlocProvider(
              providers: [
                BlocProvider<DrawingBloc>(
                  create: (_) => DrawingBloc(DrawingsRepositoryImpl()),
                ),
                BlocProvider<SettingsBloc>(
                  create: (_) => SettingsBloc(),
                ),
              ],
              child: PaintPage(),
            ),
          );
        });
  }
}

class Dummy extends StatefulWidget {
  Dummy({Key? key}) : super(key: key);

  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  Map<String, dynamic> data = {
    "specialité": '',
    "Nom:": '',
    "Téléphone:": '',
    "adresse:": '',
    "autre:": '',
  };

  void _validateForm() async {}

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (String? text) {
                if (text == null) return 'Text cant be empty!';
                if (text.isEmpty) return 'Text cant be empty!';
                return null; //this signals that it is good
              },
              onSaved: (String? text) {
                //example on how to save data
                data['Téléphone'] = text;
              },
            ),
            RaisedButton(onPressed: () {
              _validateForm();
            }),
          ],
        ));
  }
}
