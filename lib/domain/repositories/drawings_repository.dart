import 'package:dartz/dartz.dart';
import 'package:paint_app/core/error/failures.dart';
import 'package:paint_app/domain/entities/canvas_path.dart';
import 'package:paint_app/domain/entities/drawing.dart';
import 'package:paint_app/view/painter_screen/drawing_bloc/drawing_bloc.dart';

abstract class DrawingsRepository {
  Future<Either<Failure, List<Drawing>>> getDrawings();

  Future<void> storeDrawings(List<Drawing> drawings);

  void updateLastCanvasPath(CanvasPath updatedCanvasPath);
  void addNewCanvasPath(CanvasPath newCanvasPath);
  void removeLastCanvasPath();

  void nextDrawing();
  void previousDrawing();

  void duplicateDrawing();
  void deleteDrawing();
}
