import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'canvas_path.dart';

class Drawing extends Equatable {
  final List<CanvasPath> canvasPaths;
  final String sketchId;
  final String id;
  Color backgroundColor;

  Drawing({
    this.backgroundColor = Colors.white,
    required this.canvasPaths,
    required this.sketchId,
    required this.id,
  });

  void removeLastPath() {
    if (canvasPaths.isNotEmpty) canvasPaths.removeLast();
  }

  void addNewPath(CanvasPath newPath) {
    this.canvasPaths.add(newPath);
  }

  void updateLastPath(Offset newPoint) {
    if (canvasPaths.isNotEmpty) {
      canvasPaths.last.quadric(newPoint.dx, newPoint.dy);
      canvasPaths.last.drawPoints.add(newPoint);
    }
  }

  void updateLastPathOnPanEnd() {
    final Offset _lastOffset = canvasPaths.last.drawPoints.last;
    final Offset _additionalOffset =
        Offset(_lastOffset.dx + 10, _lastOffset.dy + 10);
    canvasPaths.last.drawPoints.add(_additionalOffset);
  }

  @override
  List<Object?> get props => [this.canvasPaths];
}
