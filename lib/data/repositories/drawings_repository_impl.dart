import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../datasources/database_source.dart';
import 'package:sqflite/sqflite.dart';
import '../models/canvas_path_model.dart';
import '../models/drawing_model.dart';
import '../models/sketch_model.dart';
import '../../domain/entities/sketch.dart';
import '../../domain/entities/canvas_path.dart';
import '../../domain/entities/drawing.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/drawings_repository.dart';

class DrawingsRepositoryImpl extends DrawingsRepository {
  final DatabaseSource _databaseSource;

  DrawingsRepositoryImpl(this._databaseSource);

  //!treba dohvatiti sve crteze za odabrani sketch, ovdje je casham, save pri izslasku(ili dodaj gumb za save, a pitaj hoce li save kad izlazi?)
  List<DrawingModel> _currentDrawings = [
    DrawingModel(
      sketchId: '4',
      canvasPaths: [CanvasPathModel(paint: Paint(), drawPoints: [])],
      id: DateTime.now().toIso8601String(),
    ),
  ];
  String _currentSketchId = '4';

  int _currentlyViewdSketch = 0;

  bool _canPreformAction() => _currentlyViewdSketch >= 0;

  get currentSketch => _currentDrawings;

  @override
  Future<Either<Failure, void>> getDrawings(String sketchId) async {
    try {
      _currentlyViewdSketch = 0;
      _currentSketchId = sketchId;

      final List<DrawingModel> _res =
          await _databaseSource.getDrawingsFromDatabase(sketchId);
      log("drawings from DB: " + _res.toString());
      if (_res.isNotEmpty) {
        _res.sort(
            (a, b) => DateTime.parse(a.id).compareTo(DateTime.parse(b.id)));
        _currentDrawings = _res;
      } else
        _currentDrawings = [
          DrawingModel(
            sketchId: sketchId,
            canvasPaths: [CanvasPathModel(paint: Paint(), drawPoints: [])],
            id: DateTime.now().toIso8601String(),
          ),
        ];
      return Right(null);
    } catch (err) {
      log(err.toString());
      return Left(DatabaseFailure());
    }

    //return Future.delayed(Duration.zero, () => Right(_currentDrawings.drawings));
  }

  @override
  Future<Either<Failure, void>> nextDrawing() async {
    try {
      final res = await _databaseSource
          .updateDrawing(_currentDrawings.elementAt(_currentlyViewdSketch));

      //for the first drawing
      if (res == 0)
        await _databaseSource.addNewDrawing(
          _currentDrawings.elementAt(_currentlyViewdSketch),
        );

      _currentlyViewdSketch++;
      //no more drawings
      if (_currentlyViewdSketch == _currentDrawings.length) {
        final DrawingModel _newDrawing = DrawingModel(
            canvasPaths: [],
            sketchId: _currentSketchId,
            id: DateTime.now().toIso8601String());

        await _databaseSource.addNewDrawing(_newDrawing);
        _currentDrawings.add(_newDrawing);
      }

      return Right(null);
    } catch (err) {
      _currentlyViewdSketch--;
      log(err.toString());
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> previousDrawing() async {
    try {
      if (_currentlyViewdSketch > 0) {
        await _databaseSource
            .updateDrawing(_currentDrawings.elementAt(_currentlyViewdSketch));
        _currentlyViewdSketch--;
      }
      return Right(null);
    } catch (err) {
      log(err.toString());
      return Left(DatabaseFailure());
    }

    // log("DRAWING NO:$_currentlyViewdSketch");
  }

  @override
  Future<Either<Failure, int>> deleteDrawing() async {
    try {
      int res = 0;
      if (_currentDrawings.length > 1) {
        res = await _databaseSource.deleteDrawing(
          _currentDrawings.elementAt(_currentlyViewdSketch).id,
        );
        _currentDrawings.removeAt(_currentlyViewdSketch);
        if (_currentlyViewdSketch == 0)
          _currentlyViewdSketch++;
        else
          _currentlyViewdSketch--;
      }
      return Right(res);
    } catch (err) {
      return Left(DatabaseFailure());
    }
    // log("drawings lenghts:${_currentDrawings.drawings.length}");
    // log(_currentlyViewdSketch.toString());
  }

  @override
  Future<Either<Failure, void>> duplicateDrawing() async {
    try {
      await _databaseSource
          .addNewDrawing(_currentDrawings.elementAt(_currentlyViewdSketch));
      _currentlyViewdSketch++;
      // log("inserting at $_currentlyViewdSketch");
      _currentDrawings.insert(_currentlyViewdSketch,
          _currentDrawings.elementAt(_currentlyViewdSketch - 1));
      return Right(null);
    } catch (err) {
      return Left(DatabaseFailure());
    }
  }

  @override
  void addNewCanvasPath(Paint paint, Offset offset) {
    if (_canPreformAction()) {
      final _newPath = CanvasPathModel(drawPoints: [offset], paint: paint);
      _newPath.movePathTo(offset.dx, offset.dy);
      _currentDrawings.elementAt(_currentlyViewdSketch).addNewPath(_newPath);
    }
  }

  @override
  void removeLastCanvasPath() {
    if (_canPreformAction()) {
      _currentDrawings.elementAt(_currentlyViewdSketch).removeLastPath();
    }
  }

  @override
  void updateLastCanvasPath(Offset offset, {bool isLast = false}) {
    if (_canPreformAction())
      _currentDrawings.elementAt(_currentlyViewdSketch).updateLastPath(offset);
  }

  @override
  void updateLaseCanvasPathOnPanEd() {
    if (_canPreformAction())
      _currentDrawings
          .elementAt(_currentlyViewdSketch)
          .updateLastPathOnPanEnd();
  }

  Drawing getCurrentDrawing() {
    // log('drawings length: ' + _currentDrawings.length.toString());
    // elementAt(_currentlyViewdSketch)).toMap().toString());
    return _currentDrawings.elementAt(_currentlyViewdSketch);
  }

  Drawing getPreviousDrawing() {
    if (_currentlyViewdSketch > 0)
      return _currentDrawings.elementAt(_currentlyViewdSketch - 1);
    else
      return getCurrentDrawing();
  }

  @override
  Future<Either<Failure, void>> storeDrawing() async {
    throw UnimplementedError();
  }

  /*@override
  void changeBackgroundColorOfCurrentDrawing(Color color) {
    _currentDrawings.drawings.elementAt(_currentlyViewdSketch).backgroundColor =
        color;
  }
*/

}
