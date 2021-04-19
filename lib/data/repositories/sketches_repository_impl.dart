import 'dart:developer';

import 'package:paint_app/domain/entities/drawing.dart';
import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:paint_app/domain/repositories/sketches_repository.dart';

class SketchesRepositoryImpl extends SketchesRepository {
  List<Sketch> _userSketches = [
    Sketch(
        drawings: [Drawing(canvasPaths: [])], id: "prvi", sketchName: "prvi"),
    Sketch(
        drawings: [Drawing(canvasPaths: [])], id: "drugi", sketchName: "drugi"),
    Sketch(
        drawings: [Drawing(canvasPaths: [])], id: "treci", sketchName: "treci"),
    Sketch(
        drawings: [Drawing(canvasPaths: [])],
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
  Future<Either<Failure, List<Sketch>>> addNewSketch(Sketch newSketch) async {
    try {
      _userSketches.add(newSketch);
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
      _userSketches[_index] = newSketch; //TODO: IMPLEMENT BP UPDATE
      // log(_index.toString());
      _userSketches.forEach((element) => log(element.sketchName));
      log(_userSketches[_index].sketchName);
      return Future.microtask(() => Right(null));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }
}
