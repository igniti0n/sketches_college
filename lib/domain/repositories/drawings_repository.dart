import 'dart:ui';

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/drawing.dart';

abstract class DrawingsRepository {
  Future<Either<Failure, void>> getDrawings(String sketchId);

  Future<Either<Failure, void>> saveDrawing();
  Future<Either<Failure, int>> deleteDrawing();

  Future<Either<Failure, void>> duplicateDrawing();
  // Future<Either<Failure, void>> updateDrawing();

  get currentSketch;
  get currentPage;
  get maxPage;

  void updateLastCanvasPath(Offset offset, {bool isLast = false});
  void updateLaseCanvasPathOnPanEd();
  void addNewCanvasPath(Paint paint, Offset offset);
  void removeLastCanvasPath();

  Future<Either<Failure, void>> nextDrawing();
  Future<Either<Failure, void>> previousDrawing();
  Future<Either<Failure, void>> firstDrawing();
  Future<Either<Failure, void>> lastDrawing();

  Drawing getCurrentDrawing();
  Drawing getPreviousDrawing();

  //void changeBackgroundColorOfCurrentDrawing(Color color);

}
