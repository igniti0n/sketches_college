import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:paint_app/view/animation_preview_screen/animation_bloc/animation_bloc.dart';

import 'core/navigation/router.dart';
import 'data/repositories/drawings_repository_impl.dart';
import 'data/repositories/sketches_repository_impl.dart';
import 'view/home_screen/sketches_bloc/sketches_bloc.dart';
import 'view/overlay_screens/overlay_bloc/overlay_bloc.dart';
import 'view/painter_screen/drawing_bloc/drawing_bloc.dart';
import 'view/painter_screen/settings_bloc/settings_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  //
  // debugPaintPointersEnabled = true;

  runApp(MyApp());
}

final SketchesRepositoryImpl _sketchesRepositoryImpl = SketchesRepositoryImpl();
final DrawingsRepositoryImpl _drawingsRepositoryImpl = DrawingsRepositoryImpl();

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
                create: (_) => DrawingBloc(_drawingsRepositoryImpl),
              ),
              BlocProvider<SketchesBloc>(
                create: (_) => SketchesBloc(_sketchesRepositoryImpl),
              ),
              BlocProvider<OverlayBloc>(
                create: (_) => OverlayBloc(_sketchesRepositoryImpl),
              ),
              BlocProvider<SettingsBloc>(
                create: (_) => SettingsBloc(),
              ),
              BlocProvider<AnimationBloc>(
                create: (_) => AnimationBloc(_drawingsRepositoryImpl),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              // checkerboardRasterCacheImages: true,
              debugShowCheckedModeBanner: false,
              // debugShowMaterialGrid: true,
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: TextTheme(
                      bodyText1: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ))),
              onGenerateRoute: onGenerateRoute,
            ),
          );
        });
  }
}

// final List<String> dummy = [
//   "aaaaa",
//   'bbbbb',
//   'ccccc',
//   'dddddd',
//   'eeeee',
//   'fffffff',
//   'gggggg',
//   'hhhhhhh'
// ];

// class Dummy extends StatefulWidget {
//   Dummy({Key? key}) : super(key: key);

//   @override
//   _DummyState createState() => _DummyState();
// }

// class _DummyState extends State<Dummy> {
//   late final ScrollController _appBarController;

//   @override
//   void initState() {
//     super.initState();
//     _appBarController = ScrollController();
//   }

//   @override
//   Widget build(BuildContext context) {

//     Navigator.of(context).p

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             toolbarHeight: kToolbarHeight,
//             title: SizedBox(
//               height: kToolbarHeight,
//               width: 500,
//               child: ListView.builder(
//                   itemCount: dummy.length,
//                   itemBuilder: (ctx, i) => Text(dummy[i])),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 4000,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
