import 'package:dartz/dartz.dart';
import 'package:paint_app/core/error/failures.dart';
import 'package:paint_app/domain/entities/sketch.dart';

abstract class SketchesRepository {
  Either<Failure, Sketch> getSketch(String id);
  Future<Either<Failure, List<Sketch>>> getSketches();

  Future<Either<Failure, List<Sketch>>> deleteSketch(String id);
  Future<Either<Failure, List<Sketch>>> addNewSketch(Sketch newSketch);
}
