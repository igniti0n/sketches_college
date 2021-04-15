import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint_app/domain/entities/canvas_path.dart';

import '../../domain/entities/drawing.dart';

class AppPainter extends CustomPainter {
  // final List<Offset> drawPoints;
  // final Color drawColor;
  // final double strokeWidth;
  final Drawing drawing;

  AppPainter({
    // required this.drawColor,
    // required this.drawPoints,
    // required this.strokeWidth,
    required this.drawing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // log("PAINTING");
    final List<CanvasPath> canvasPaths = drawing.canvasPaths;

    var _paint = Paint();

    // let's pretend this rectangle is an image.
    // in this case, we don't want anything erased from the image,
    // and we also want the image to be drawn under the eraser.

    if (canvasPaths.isNotEmpty) {
      canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
      canvasPaths.forEach((CanvasPath canvasPath) {
        if (canvasPath.drawPoints.isNotEmpty) {
          final Paint _currentPathSettings = canvasPath.paint;

          //
          // canvas.drawRect(
          //     Rect.fromLTWH(100, 100, 100, 100), Paint()..color = Colors.white);

          // // after having drawn our image, we start a new layer using saveLayer().
          // canvas.saveLayer(
          //     Rect.fromLTWH(0, 0, size.width, size.height), Paint());

          _paint = canvasPath.paint..style = PaintingStyle.stroke;

          final _raidus = math.sqrt(_currentPathSettings.strokeWidth) / 20;

          canvas.drawPath(canvasPath.path, _paint);

          if (_currentPathSettings.strokeWidth > 1)
            for (int i = 0; i < canvasPath.drawPoints.length - 1; i++) {
              // canvas.drawLine(canvasPath.drawPoints[i],
              //     canvasPath.drawPoints[i + 1], _paint);
              canvas.drawCircle(
                  canvasPath.drawPoints[i],
                  _currentPathSettings.strokeWidth < 1
                      ? _currentPathSettings.strokeWidth
                      : _raidus,
                  _paint);
            }
        }

        // erasing parts of the first line where intersected with this line.
        // canvas.drawLine(
        //     Offset(100, 600),
        //     Offset(600, 100),
        //     Paint()
        //       ..color = Colors.red
        //       ..strokeWidth = 5.0
        //       ..blendMode = BlendMode.clear);

        // first composite this layer and then draw it over the previously drawn layers.
      });
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant AppPainter oldDelegate) => true;
}
