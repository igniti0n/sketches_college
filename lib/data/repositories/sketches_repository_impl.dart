import 'dart:developer';

import 'package:paint_app/data/models/sketch_model.dart';
import 'package:paint_app/domain/entities/drawing.dart';
import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:paint_app/domain/repositories/sketches_repository.dart';

class SketchesRepositoryImpl extends SketchesRepository {
  //!treba mi samo prvi drawing sketcha z aprikaz na home screenu
  List<SketchModel> _userSketches = [
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'prvi')],
        id: "prvi",
        sketchName: "prvi"),
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'drugi')],
        id: "drugi",
        sketchName: "drugi"),
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'treci')],
        id: "treci",
        sketchName: "treci"),
    SketchModel(
        drawings: [Drawing(canvasPaths: [], sketchId: 'cetvrti')],
        id: "cetvrti",
        sketchName: "cetvrti"),
  ];

  @override
  Either<Failure, Sketch> getSketch(String id) {
    try {
      return Right(
          _userSketches.firstWhere((Sketch sketch) => sketch.id == id));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }

  //TODO: IMPLEMENT DB IN ALL THIS

  @override
  Future<Either<Failure, List<Sketch>>> deleteSketch(String id) async {
    try {
      _userSketches.removeWhere((element) => element.id == id);

      return Future.microtask(() => Right(_userSketches));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, List<Sketch>>> getSketches() async {
    try {
      // _userSketches.forEach((element) => log(element.sketchName));
      return Future.microtask(() => Right(_userSketches));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, List<Sketch>>> addNewSketch() async {
    try {
      _userSketches.add(SketchModel(
          sketchName: 'new sketch',
          drawings: [],
          id: DateTime.now().toIso8601String()));
      return Future.microtask(() => Right(_userSketches));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editSketch(Sketch newSketch) async {
    try {
      final _index =
          _userSketches.indexWhere((element) => element.id == newSketch.id);
      if (_index == -1) return Left(SketchNotFoundFailure());
      _userSketches[_index] = SketchModel(
        sketchName: newSketch.sketchName,
        drawings: newSketch.drawings,
        id: newSketch.id,
      ); //TODO: IMPLEMENT BP UPDATE
      // log(_index.toString());
      _userSketches.forEach((element) => log(element.sketchName));
      log(_userSketches[_index].sketchName);
      return Future.microtask(() => Right(null));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }
}
