import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/utils/paint_from.dart';
import '../../../domain/entities/canvas_path.dart';

import '../../../domain/entities/drawing.dart';

class AppPainter extends CustomPainter {
  final Drawing drawing;
  final bool isForeground;
  final isPreview;

  AppPainter({
    required this.drawing,
    this.isForeground = true,
    this.isPreview = false,
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

          final _radius = math.sqrt(_currentPathSettings.strokeWidth) /
              ((_currentPathSettings.strokeWidth > 6) ? 20 : 60);

          Path _path = Path.from(canvasPath.path);
          // if (isPreview) _path = _path.shift(Offset(-100, 0));

          canvas.drawPath(_path, _paint);

          if (_currentPathSettings.strokeWidth > 1)
            for (int i = 0; i < canvasPath.drawPoints.length - 1; i++) {
              canvas.drawCircle(
                  canvasPath
                      .drawPoints[i], //.translate((isPreview ? -100 : 0), 0),
                  _currentPathSettings.strokeWidth < 1
                      ? _currentPathSettings.strokeWidth
                      : _radius,
                  _paint);
            }
        }
      });
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
  bool shouldRepaint(covariant AppPainter oldDelegate) => true;
}
