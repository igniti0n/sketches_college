import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint_app/core/utils/paint_from.dart';
import 'package:paint_app/domain/entities/canvas_path.dart';

import '../../domain/entities/drawing.dart';

class AppPainter extends CustomPainter {
  final Drawing drawing;
  final bool isForeground;

  AppPainter({
    required this.drawing,
    this.isForeground = true,
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

          if (!isForeground) _paint..color = _paint.color.withOpacity(1);

          final _raidus = math.sqrt(_currentPathSettings.strokeWidth) / 20;

          canvas.drawPath(canvasPath.path, _paint);

          if (_currentPathSettings.strokeWidth > 1)
            for (int i = 0; i < canvasPath.drawPoints.length - 1; i++) {
              canvas.drawCircle(
                  canvasPath.drawPoints[i],
                  _currentPathSettings.strokeWidth < 1
                      ? _currentPathSettings.strokeWidth
                      : _raidus,
                  _paint);
            }
        }
      });
    }
    if (!isForeground)
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()
            ..blendMode = BlendMode.srcIn
            ..color = Color.fromRGBO(0, 0, 0, 0.2)
            ..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AppPainter oldDelegate) => true;
}
