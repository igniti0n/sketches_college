import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/utils/paint_from.dart';
import '../../../domain/entities/canvas_path.dart';

import '../../../domain/entities/drawing.dart';

class AppPainter extends CustomPainter {
  final Drawing drawing;
  final bool isForeground;
  final bool isFirstPage;

  final isPreview;

  AppPainter({
    required this.drawing,
    this.isForeground = true,
    this.isPreview = false,
    this.isFirstPage = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // log("PAINTING");

    final List<CanvasPath> canvasPaths = drawing.canvasPaths;

    var _paint = Paint();

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    if (canvasPaths.isNotEmpty) {
      canvasPaths.forEach((CanvasPath canvasPath) {
        if (canvasPath.drawPoints.isNotEmpty) {
          final Paint _currentPathSettings = canvasPath.paint;

          _paint = paintFrom(canvasPath.paint)..style = PaintingStyle.stroke;
          // ..color = Colors.black.withAlpha(80);

          if (!isForeground) _paint..color = _paint.color.withOpacity(1);

          final _radius = math.sqrt(_currentPathSettings.strokeWidth) /
              ((_currentPathSettings.strokeWidth > 6) ? 20 : 60);

          Path _path = Path.from(canvasPath.path);
          // if (isPreview) _path = _path.shift(Offset(-100, 0));

          canvas.drawPath(_path, _paint);

          // if (_currentPathSettings.strokeWidth > 1) {
          //   final _arrayLength = canvasPath.drawPoints.length;

          //   canvas.drawCircle(
          //       canvasPath
          //           .drawPoints[0], //.translate((isPreview ? -100 : 0), 0),
          //       _currentPathSettings.strokeWidth < 1
          //           ? _currentPathSettings.strokeWidth
          //           : _radius,
          //       _paint);

          //   for (int i = 1; i < _arrayLength - 1; i++) {
          //     final first = canvasPath.drawPoints[i];
          //     final second = canvasPath.drawPoints[i - 1];

          //     final _distance = (math.sqrt(math.pow(first.dx - second.dx, 2) +
          //         math.pow(first.dy - second.dy, 2)));
          //     if (_distance <= 10)
          //       canvas.drawCircle(
          //           canvasPath
          //               .drawPoints[i], //.translate((isPreview ? -100 : 0), 0),
          //           _currentPathSettings.strokeWidth < 1
          //               ? _currentPathSettings.strokeWidth
          //               : _radius,
          //           _paint);
          //   }
          // }

          if (_currentPathSettings.strokeWidth > 1) {
            final _arrayLength = canvasPath.drawPoints.length;

            for (int i = 1; i < _arrayLength - 1; i++) {
              canvas.drawCircle(
                  canvasPath
                      .drawPoints[i], //.translate((isPreview ? -100 : 0), 0),
                  _currentPathSettings.strokeWidth < 1
                      ? _currentPathSettings.strokeWidth
                      : _radius,
                  _paint);
            }
          }
        }
      });
      if (!isForeground) log('painting background fml fml');
    }

    if (!isForeground)
      canvas.drawColor(Color.fromRGBO(0, 0, 0, 0.2), BlendMode.srcIn);
    // drawRect(
    //     Rect.fromLTWH(0, 0, size.width, size.height),
    //     Paint()
    //       ..blendMode = BlendMode.srcIn
    //       ..color = Color.fromRGBO(0, 0, 0, 0.2)
    //       ..style = PaintingStyle.fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AppPainter oldDelegate) {
    if (isForeground || isFirstPage) return true;
    return oldDelegate.drawing != this.drawing;
  }
}
