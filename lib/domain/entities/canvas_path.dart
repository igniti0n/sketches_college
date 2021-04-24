import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CanvasPath extends Equatable {
  final Path path = Path();
  Paint paint;
  final List<Offset> drawPoints;
  CanvasPath({
    required this.paint,
    required this.drawPoints,
  });

  //*used when  fetching form database, to make the path out of fetched offsets
  void createPathFromOffsets() {
    if (drawPoints.isNotEmpty) {
      movePathTo(drawPoints.first.dx, drawPoints.first.dy);
      for (int i = 1; i < drawPoints.length; i++) {
        _doQuadricPathMovment(drawPoints[i].dx, drawPoints[i].dy,
            drawPoints[i - 1].dx, drawPoints[i - 1].dy);
      }
    }
  }

  void movePathTo(double x, double y) {
    path.moveTo(x, y);
  }

  void quadric(double x, double y) {
    _doQuadricPathMovment(x, y, drawPoints.last.dx, drawPoints.last.dy);
  }

  void _doQuadricPathMovment(double x, double y, double xx, double yy) {
    //calculate distance from last point
    final _distance = (sqrt(pow(x - xx, 2) + pow(y - yy, 2)));

    //  dev.log("distance:    " + _distance.toString());
    if (paint.strokeWidth <= 2)
      path.quadraticBezierTo(xx, yy, x, y);
    else if (_distance > 2.5)
      // path.arcToPoint(Offset(x, y));
      path.quadraticBezierTo(xx, yy, x, y);
    else
      path.moveTo(x, y);
  }

  @override
  List<Object?> get props => [drawPoints, paint];
}
