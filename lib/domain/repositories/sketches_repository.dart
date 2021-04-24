import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/sketch.dart';

abstract class SketchesRepository {
  //Either<Failure, Sketch> getSketch(String id);
  Future<Either<Failure, List<Sketch>>> getSketches();

  Future<Either<Failure, void>> deleteSketch(String id);
  Future<Either<Failure, List<Sketch>>> addNewSketch();
  Future<Either<Failure, void>> editSketch(String newName, String id);

  List<Sketch> get currentSketches;
}
