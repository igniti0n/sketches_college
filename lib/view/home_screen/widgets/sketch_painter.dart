import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/utils/paint_from.dart';
import '../../../domain/entities/canvas_path.dart';

class SketchPainter extends CustomPainter {
  final List<CanvasPath> _canvasPaths;
  final bool isLandscape;

  SketchPainter(this._canvasPaths, this.isLandscape);

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

          final List<Offset> _adjustedDrawPoints = canvasPath.drawPoints
              .map((e) => e.scale(1 / 1.5, 1 / 2))
              .toList();

          final double _pathScale = isLandscape ? 10 : 1.5;

          if (_currentPathSettings.strokeWidth <= 2)
            canvas.drawPath(
                canvasPath.path.shift(Offset(-1, -1)
                    .scale(size.width / _pathScale, size.height / _pathScale)),
                _paint);

          if (_currentPathSettings.strokeWidth > 2)
            for (int i = 0; i < _adjustedDrawPoints.length - 1; i++) {
              canvas.drawCircle(
                  _adjustedDrawPoints[i],
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
