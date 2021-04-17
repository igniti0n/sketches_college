import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/contants.dart';
import 'package:paint_app/core/navigation/router.dart';
import 'package:paint_app/core/utils/paint_from.dart';
import 'package:paint_app/domain/entities/canvas_path.dart';
import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/view/home_screen/sketches_bloc/sketches_bloc.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:paint_app/view/painter_screen/drawing_bloc/drawing_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final _sketchesBloc = BlocProvider.of<SketchesBloc>(context);
    _sketchesBloc.add(FetchAllSketches());

    return Scaffold(
      backgroundColor: dark,
      body: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: medium,
        ),
        child: BlocBuilder<SketchesBloc, SketchesState>(
          builder: (context, state) {
            dev.log(state.toString());
            if (state is LoadingSketches) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Error) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is SketchesLoaded) {
              return GridView.builder(
                  itemCount: state.sketches.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: _deviceSize.width / 2),
                  itemBuilder: (ctx, index) =>
                      SketchWidget(sketch: state.sketches[index]));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //TODO: DA DODAJE U BAZU I DA SE OTVORI IME ZA DAVANJE SKETCHU I ODLAZAK NA SKETCH
        onPressed: () => _sketchesBloc.add(AddNewSketch()),
        isExtended: true,
        backgroundColor: Colors.purple[400],
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}

class SketchWidget extends StatelessWidget {
  final Sketch sketch;
  SketchWidget({
    Key? key,
    required this.sketch,
  }) : super(key: key);

  final Random rand = Random();

  @override
  Widget build(BuildContext context) {
    final _sketchBloc = BlocProvider.of<SketchesBloc>(context);
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
              Transform.scale(
                scale: _orientation == Orientation.portrait ? 0.3 : 0.6,
                child: CustomPaint(
                  willChange: false,
                  painter: SketchPainter(sketch.drawings.first.canvasPaths),
                  child: Container(),
                ),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(100),
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(60)),
                                  shape: BoxShape.circle,
                                ),
                                child: LayoutBuilder(
                                  builder: (ctx, cons) => Icon(
                                    Icons.edit,
                                    size: cons.maxWidth / 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(100),
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(60)),
                                  shape: BoxShape.circle,
                                ),
                                child: LayoutBuilder(
                                  builder: (ctx, cons) => Icon(
                                    Icons.edit,
                                    size: cons.maxWidth / 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
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

class CircleClipper extends CustomClipper<Path> {
  final Path _path = Path();

  @override
  getClip(Size size) {
    _path.addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.95,
        height: size.height * 0.95));

    return _path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

class SketchPainter extends CustomPainter {
  final List<CanvasPath> _canvasPaths;

  SketchPainter(this._canvasPaths);

  final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    // log("PAINTING");

    final List<CanvasPath> canvasPaths = _canvasPaths;

    var _paint = Paint();
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    if (canvasPaths.isNotEmpty) {
      canvasPaths.forEach((CanvasPath canvasPath) {
        if (canvasPath.drawPoints.isNotEmpty) {
          final Paint _currentPathSettings = canvasPath.paint;

          _paint = paintFrom(canvasPath.paint)..style = PaintingStyle.stroke;

          // if (!isForeground) _paint..color = _paint.color.withOpacity(1);

          final _radius = sqrt(_currentPathSettings.strokeWidth) / 20;

          canvas.drawPath(canvasPath.path, _paint);

          if (_currentPathSettings.strokeWidth > 1)
            for (int i = 0; i < canvasPath.drawPoints.length - 1; i++) {
              canvas.drawCircle(
                  canvasPath.drawPoints[i],
                  _currentPathSettings.strokeWidth < 1
                      ? _currentPathSettings.strokeWidth
                      : _radius,
                  _paint);
            }
        }
      });
    }

    // canvas.drawColor(Color.fromRGBO(0, 0, 0, 0.2), BlendMode.srcIn);
    // canvas.drawRect(
    //     Rect.fromLTWH(0, 0, size.width, size.height),
    //     Paint()
    //       ..blendMode = BlendMode.srcIn
    //       ..color = Color.fromRGBO(0, 0, 0, 0.2)
    //       ..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
