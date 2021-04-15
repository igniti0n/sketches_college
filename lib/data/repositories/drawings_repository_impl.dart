import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint_app/domain/entities/animated_sketch.dart';
import 'package:paint_app/domain/entities/canvas_path.dart';
import 'package:paint_app/domain/entities/drawing.dart';
import 'package:paint_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:paint_app/domain/repositories/drawings_repository.dart';

class DrawingsRepositoryImpl extends DrawingsRepository {
  AnimatedSketch _animatedSketch = AnimatedSketch(drawings: [
    Drawing(canvasPaths: [CanvasPath(paint: Paint(), drawPoints: [])]),
  ]);
  int _currentlyViewdSketch = 0;

  @override
  Future<Either<Failure, List<Drawing>>> getDrawings() {
    return Future.delayed(Duration.zero, () => Right(_animatedSketch.drawings));
  }

  bool _canPreformAction() => _currentlyViewdSketch >= 0;

  @override
  void addNewCanvasPath(CanvasPath newCanvasPath) {
    if (_canPreformAction())
      _animatedSketch.drawings
          .elementAt(_currentlyViewdSketch)
          .addNewPath(newCanvasPath);
  }

  @override
  void removeLastCanvasPath() {
    if (_canPreformAction()) {
      _animatedSketch.drawings
          .elementAt(_currentlyViewdSketch)
          .removeLastPath();
    }
  }

  @override
  void updateLastCanvasPath(CanvasPath updatedCanvasPath) {
    if (_canPreformAction())
      _animatedSketch.drawings
          .elementAt(_currentlyViewdSketch)
          .updateLastPath(updatedCanvasPath);
  }

  @override
  Future<void> storeDrawings(List<Drawing> drawings) {
    // TODO: implement storeDrawings
    throw UnimplementedError();
  }

  Drawing getCurrentDrawing() {
    log(_animatedSketch.drawings
        .elementAt(_currentlyViewdSketch)
        .canvasPaths
        .toString());
    return _animatedSketch.drawings.elementAt(_currentlyViewdSketch);
  }

  Drawing getPreviousDrawing() {
    if (_currentlyViewdSketch > 0)
      return _animatedSketch.drawings.elementAt(_currentlyViewdSketch - 1);
    else
      return getCurrentDrawing();
  }

  @override
  void nextDrawing() {
    _currentlyViewdSketch = _currentlyViewdSketch + 1;
    log("DRAWING NO:$_currentlyViewdSketch");
    if (_currentlyViewdSketch == _animatedSketch.drawings.length)
      _animatedSketch.drawings.add(Drawing(canvasPaths: []));
  }

  @override
  void previousDrawing() {
    if (_currentlyViewdSketch > 0) _currentlyViewdSketch--;
    log("DRAWING NO:$_currentlyViewdSketch");
  }

  @override
  void deleteDrawing() {
    if (_currentlyViewdSketch > 0) {
      _currentlyViewdSketch--;
      _animatedSketch.drawings.removeLast();
    }
  }

  @override
  void duplicateDrawing() {
    _currentlyViewdSketch++;
    _animatedSketch.drawings.insert(
        _currentlyViewdSketch,
        Drawing(
            canvasPaths: List.from(_animatedSketch.drawings.last.canvasPaths)));
  }
}
