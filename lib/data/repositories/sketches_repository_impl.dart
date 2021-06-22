import 'dart:developer';

import '../datasources/database_source.dart';

import '../models/sketch_model.dart';
import '../../domain/entities/sketch.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/sketches_repository.dart';

class SketchesRepositoryImpl extends SketchesRepository {
  final DatabaseSource _databaseSource;
  SketchesRepositoryImpl(this._databaseSource);
  //!treba mi samo prvi drawing sketcha z aprikaz na home screenu
  List<SketchModel> _userSketches = [];

  @override
  List<Sketch> get currentSketches => _userSketches;

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
      log(error.toString());
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Sketch>>> addNewSketch() async {
    try {
      // throw UnimplementedError();
      final SketchModel _newSketch = SketchModel(
          sketchName: 'new sketch',
          drawings: [],
          id: DateTime.now().toIso8601String());
      log(DateTime.now().toIso8601String());
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
