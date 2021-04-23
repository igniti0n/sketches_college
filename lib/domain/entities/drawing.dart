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

  void updateLastPath(CanvasPath newPath) {
    canvasPaths.last = newPath;
  }

  @override
  List<Object?> get props => [this.canvasPaths];
}
