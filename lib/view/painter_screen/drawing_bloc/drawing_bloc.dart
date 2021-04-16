import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:paint_app/data/repositories/drawings_repository_impl.dart';
import 'package:paint_app/domain/entities/canvas_path.dart';
import 'package:paint_app/domain/entities/drawing.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final DrawingsRepositoryImpl _drawingsRepositoryImpl;
  DrawingBloc(this._drawingsRepositoryImpl)
      : super(DrawingInitial(
            currentDrawing: Drawing(
              canvasPaths: [],
            ),
            previousDrawing: Drawing(canvasPaths: [])));

  @override
  Stream<DrawingState> mapEventToState(
    DrawingEvent event,
  ) async* {
    //  log("DRAWING event:" + event.toString());
    yield DrawingLoading(
      currentDrawing: _drawingsRepositoryImpl.getCurrentDrawing(),
      previousDrawing: _drawingsRepositoryImpl.getPreviousDrawing(),
    );

    if (event is UpdateDrawing) {
      _drawingsRepositoryImpl.updateLastCanvasPath(event.canvasPath);
    } else if (event is StartDrawing) {
      _drawingsRepositoryImpl.addNewCanvasPath(event.canvasPath);
    } else if (event is Undo) {
      _drawingsRepositoryImpl.removeLastCanvasPath();
    } else if (event is NextDrawing) {
      _drawingsRepositoryImpl.nextDrawing();
    } else if (event is PreviousDrawing) {
      _drawingsRepositoryImpl.previousDrawing();
    } else if (event is DuplicateDrawing) {
      _drawingsRepositoryImpl.duplicateDrawing();
    } else if (event is DeleteDrawing) {
      _drawingsRepositoryImpl.deleteDrawing();
    }
    yield DrawingLoaded(
      currentDrawing: _drawingsRepositoryImpl.getCurrentDrawing(),
      previousDrawing: _drawingsRepositoryImpl.getPreviousDrawing(),
    );
  }
}
