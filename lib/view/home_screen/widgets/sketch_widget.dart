import 'dart:math';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/view/overlay_screens/bloc/overlay_bloc.dart';

import '../../../contants.dart';
import '../../../core/navigation/router.dart';
import '../../../domain/entities/sketch.dart';
import '../../painter_screen/drawing_bloc/drawing_bloc.dart';
import '../home_screen.dart';
import '../sketches_bloc/sketches_bloc.dart';
import 'sketch_button.dart';
import 'sketch_painter.dart';

class SketchWidget extends StatelessWidget {
  final Sketch sketch;
  SketchWidget({
    Key? key,
    required this.sketch,
  }) : super(key: key);

  final Random rand = Random();

  @override
  Widget build(BuildContext context) {
    // final _sketchBloc = BlocProvider.of<SketchesBloc>(context);
    final _orientation = MediaQuery.of(context).orientation;

    return GestureDetector(
      onTap: () {
        BlocProvider.of<DrawingBloc>(context).add(ScreenOpened(sketch));
        Navigator.pushReplacementNamed(context, PAINT_SCREEN_ROUTE);
      },
      child: Container(
        alignment: Alignment.center,
        child: ClipPath(
          clipper: CircleClipper(),
          child: Stack(
            children: [
              // Transform.scale(
              //   scale: 1, //_orientation == Orientation.portrait ? 1 : 0.6,
              //   child:
              CustomPaint(
                willChange: false,
                isComplex: false,
                painter: SketchPainter(sketch.drawings.first.canvasPaths,
                    _orientation == Orientation.landscape),
                child: Container(
                    // color: Colors.green,
                    ),
              ),
              // ),
              Container(
                color: Colors.grey.withAlpha(150),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LayoutBuilder(builder: (ctx, cons) {
                      // dev.log(cons.toString());
                      return SizedBox(
                        width: cons.maxWidth / 1.5,
                        height: cons.maxHeight / 2,
                        child: AutoSizeText(
                          sketch.sketchName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 140,
                          ),
                          maxFontSize: 40,
                        ),
                      );
                    }),
                  )),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (ctx, cons) => Row(
                        children: [
                          Expanded(
                            child: SketchButton(
                              icon: Icons.remove_circle,
                              splashColor: Colors.red[900]!,
                              onTap: (details) {},
                              maxWidth: cons.maxWidth,
                            ),
                          ),
                          Expanded(
                            child: SketchButton(
                              icon: Icons.edit,
                              splashColor: Colors.purple,
                              onTap: (details) =>
                                  BlocProvider.of<OverlayBloc>(context).add(
                                      ShowEditOverlay(
                                          sketch: sketch, context: context)),
                              maxWidth: cons.maxWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: dark, width: 4),
          //borderRadius: BorderRadius.all(Radius.circular(140)),
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.all(4),
      ),
    );
  }
}
