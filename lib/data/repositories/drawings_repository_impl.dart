import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../datasources/database_source.dart';
import '../models/canvas_path_model.dart';
import '../models/drawing_model.dart';
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

  int _currentlyViewdDrawing = 0;

  bool _canPreformAction() => _currentlyViewdDrawing >= 0;

  get currentSketch => _currentDrawings;

  get currentPage => _currentlyViewdDrawing + 1;
  get maxPage => _currentDrawings.length;

  @override
  Future<Either<Failure, void>> getDrawings(String sketchId) async {
    try {
      _currentlyViewdDrawing = 0;
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
  Future<Either<Failure, void>> saveDrawing() async {
    try {
      final res = await _databaseSource
          .updateDrawing(_currentDrawings.elementAt(_currentlyViewdDrawing));

      if (res == 0)
        await _databaseSource.addNewDrawing(
          _currentDrawings.elementAt(_currentlyViewdDrawing),
        );

      return Right(null);
    } catch (err) {
      log(err.toString());
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> nextDrawing() async {
    try {
      final res = await _databaseSource
          .updateDrawing(_currentDrawings.elementAt(_currentlyViewdDrawing));
      // log(res.toString());
      //for the first drawing
      if (res == 0)
        await _databaseSource.addNewDrawing(
          _currentDrawings.elementAt(_currentlyViewdDrawing),
        );

      _currentlyViewdDrawing++;

      // log((_currentlyViewdDrawing == _currentDrawings.length).toString());
      // log(_currentlyViewdDrawing.toString());
      // log(_currentDrawings.length.toString());
      //no more drawings
      if (_currentlyViewdDrawing == _currentDrawings.length) {
        final DrawingModel _newDrawing = DrawingModel(
            canvasPaths: [],
            sketchId: _currentSketchId,
            id: DateTime.now().toIso8601String());

        await _databaseSource.addNewDrawing(_newDrawing);
        _currentDrawings.add(_newDrawing);
      }

      return Right(null);
    } catch (err) {
      // _currentlyViewdDrawing--;
      log(err.toString());
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> previousDrawing() async {
    try {
      if (_currentlyViewdDrawing > 0) {
        await _databaseSource
            .updateDrawing(_currentDrawings.elementAt(_currentlyViewdDrawing));
        _currentlyViewdDrawing--;
      }
      return Right(null);
    } catch (err) {
      log(err.toString());
      return Left(DatabaseFailure());
    }

    // log("DRAWING NO:$_currentlyViewdDrawing");
  }

  @override
  Future<Either<Failure, void>> firstDrawing() async {
    try {
      await _databaseSource
          .updateDrawing(_currentDrawings.elementAt(_currentlyViewdDrawing));
      _currentlyViewdDrawing = 0;

      return Right(null);
    } catch (err) {
      log(err.toString());
      return Left(DatabaseFailure());
    }

    // log("DRAWING NO:$_currentlyViewdDrawing");
  }

  @override
  Future<Either<Failure, void>> lastDrawing() async {
    try {
      await _databaseSource
          .updateDrawing(_currentDrawings.elementAt(_currentlyViewdDrawing));
      _currentlyViewdDrawing = _currentDrawings.length - 1;

      return Right(null);
    } catch (err) {
      log(err.toString());
      return Left(DatabaseFailure());
    }

    // log("DRAWING NO:$_currentlyViewdDrawing");
  }

  @override
  Future<Either<Failure, int>> deleteDrawing() async {
    try {
      int res = 0;

      if (_currentDrawings.length > 1) {
        res = await _databaseSource.deleteDrawing(
          _currentDrawings.elementAt(_currentlyViewdDrawing).id,
        );
        _currentDrawings.removeAt(_currentlyViewdDrawing);
        if (_currentlyViewdDrawing == _currentDrawings.length)
          _currentlyViewdDrawing--;
        //   _currentlyViewdDrawing++;
        // else
      } else {
        _currentDrawings[_currentlyViewdDrawing] = DrawingModel(
          canvasPaths: [],
          sketchId: _currentSketchId,
          id: _currentDrawings.elementAt(_currentlyViewdDrawing).id,
        );
      }
      return Right(res);
    } catch (err) {
      return Left(DatabaseFailure());
    }
    // log("drawings lenghts:${_currentDrawings.drawings.length}");
    // log(_currentlyViewdDrawing.toString());
  }

  @override
  Future<Either<Failure, void>> duplicateDrawing() async {
    try {
      final DrawingModel _newDrawing = DrawingModel(
        canvasPaths:
            List.from(_currentDrawings[_currentlyViewdDrawing].canvasPaths),
        sketchId: _currentSketchId,
        id: DateTime.now().toIso8601String(),
      );
      await _databaseSource.addNewDrawing(_newDrawing);
      _currentlyViewdDrawing++;
      // log("inserting at $_currentlyViewdDrawing");
      _currentDrawings.insert(_currentlyViewdDrawing, _newDrawing);
      return Right(null);
    } catch (err) {
      return Left(DatabaseFailure());
    }
  }

  @override
  void addNewCanvasPath(Paint paint, Offset offset) {
    if (_canPreformAction()) {
      final _newPath = CanvasPathModel(
          drawPoints: [Offset(offset.dx, offset.dy)], paint: paint);
      _newPath.movePathTo(offset.dx, offset.dy);
      _currentDrawings.elementAt(_currentlyViewdDrawing).addNewPath(_newPath);
    }
  }

  @override
  void removeLastCanvasPath() {
    if (_currentlyViewdDrawing >= 0) {
      _currentDrawings.elementAt(_currentlyViewdDrawing).removeLastPath();
    }
  }

  @override
  void updateLastCanvasPath(Offset offset, {bool isLast = false}) {
    if (_canPreformAction())
      _currentDrawings.elementAt(_currentlyViewdDrawing).updateLastPath(offset);
  }

  @override
  void updateLaseCanvasPathOnPanEd() {
    if (_canPreformAction())
      _currentDrawings
          .elementAt(_currentlyViewdDrawing)
          .updateLastPathOnPanEnd();
  }

  Drawing getCurrentDrawing() {
    // log('drawings length: ' + _currentDrawings.length.toString());
    // elementAt(_currentlyViewdDrawing)).toMap().toString());
    return _currentDrawings.elementAt(_currentlyViewdDrawing);
  }

  Drawing getPreviousDrawing() {
    if (_currentlyViewdDrawing > 0)
      return _currentDrawings.elementAt(_currentlyViewdDrawing - 1);
    else
      return getCurrentDrawing();
  }

  /*@override
  void changeBackgroundColorOfCurrentDrawing(Color color) {
    _currentDrawings.drawings.elementAt(_currentlyViewdDrawing).backgroundColor =
        color;
  }
*/

}
