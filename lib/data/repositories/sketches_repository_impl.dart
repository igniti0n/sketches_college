import 'dart:developer';

import 'package:paint_app/data/datasources/database_source.dart';

import '../models/sketch_model.dart';
import '../../domain/entities/drawing.dart';
import '../../domain/entities/sketch.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/sketches_repository.dart';

class SketchesRepositoryImpl extends SketchesRepository {
  final DatabaseSource _databaseSource;
  SketchesRepositoryImpl(this._databaseSource);
  //!treba mi samo prvi drawing sketcha z aprikaz na home screenu
  List<SketchModel> _userSketches = [
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'prvi', id: '1')],
        id: "prvi",
        sketchName: "prvi"),
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'drugi', id: '2')],
        id: "drugi",
        sketchName: "drugi"),
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'treci', id: '3')],
        id: "treci",
        sketchName: "treci"),
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'cetvrti', id: '4')],
        id: "cetvrti",
        sketchName: "cetvrti"),
  ];

  /* @override
  Either<Failure, Sketch> getSketch(String id) {
    try {
      return Right(
          _userSketches.firstWhere((Sketch sketch) => sketch.id == id));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }*/

  @override
  Future<Either<Failure, void>> deleteSketch(String id) async {
    try {
      await _databaseSource.deleteSketch(id);
      _userSketches.removeWhere((element) => element.id == id);

      return Future.microtask(() => Right(null));
    } catch (error) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Sketch>>> getSketches() async {
    try {
      final List<SketchModel> result =
          await _databaseSource.getSketchesFromDatabase();
      _userSketches = result;
      return Right(result);
    } catch (error) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Sketch>>> addNewSketch() async {
    try {
      final SketchModel _newSketch = SketchModel(
          sketchName: 'new sketch',
          drawings: [],
          id: DateTime.now().toIso8601String());

      await _databaseSource.addNewSketch(_newSketch);

      _userSketches.add(_newSketch);
      return Right(_userSketches);
    } catch (error) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editSketch(String newName, String id) async {
    try {
      final _index = _userSketches.indexWhere((element) => element.id == id);
      if (_index == -1) return Left(NotFoundFailure());

      final SketchModel _updatedSketch = SketchModel(
        sketchName: newName,
        drawings: _userSketches[_index].drawings,
        id: id,
      );
      final int res = await _databaseSource.updateSketch(_updatedSketch);
      if (res == 0) return Left(NotFoundFailure());
      _userSketches[_index] = _updatedSketch;

      return Future.microtask(() => Right(null));
    } catch (error) {
      return Left(NotFoundFailure());
    }
  }
}
