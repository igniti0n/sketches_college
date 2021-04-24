import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import '../../../core/error/failures.dart';
import '../../../domain/repositories/drawings_repository.dart';
import '../../../domain/entities/drawing.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final DrawingsRepository _drawingsRepositoryImpl;
  DrawingBloc(this._drawingsRepositoryImpl)
      : super(
          DrawingInitial(
              currentDrawing: Drawing(canvasPaths: [], sketchId: '', id: ''),
              previousDrawing: Drawing(canvasPaths: [], sketchId: '', id: '')),
        );

  @override
  Stream<DrawingState> mapEventToState(
    DrawingEvent event,
  ) async* {
    log("DRAWING event:" + event.toString());
    yield DrawingLoading(
      currentDrawing: _drawingsRepositoryImpl.getCurrentDrawing(),
      previousDrawing: _drawingsRepositoryImpl.getPreviousDrawing(),
    );

    if (event is UpdateDrawing) {
      _drawingsRepositoryImpl.updateLastCanvasPath(event.offset);
      yield _success();
    } else if (event is StartDrawing) {
      _drawingsRepositoryImpl.addNewCanvasPath(event.paint, event.offset);
      yield _success();
    } else if (event is EndDrawing) {
      _drawingsRepositoryImpl.updateLaseCanvasPathOnPanEd();
      yield _success();
    } else if (event is Undo) {
      _drawingsRepositoryImpl.removeLastCanvasPath();
      yield _success();
    } else if (event is PreviousDrawing) {
      final either = await _drawingsRepositoryImpl.previousDrawing();
      yield _yieldState(either, 'Failed to update.');
    } else if (event is NextDrawing) {
      final either = await _drawingsRepositoryImpl.nextDrawing();
      yield _yieldState(either, 'Failed to update drawing.');
    } else if (event is DuplicateDrawing) {
      final either = await _drawingsRepositoryImpl.duplicateDrawing();
      yield _yieldState(either, 'Failed to duplicate the drawing.');
    } else if (event is DeleteDrawing) {
      final either = await _drawingsRepositoryImpl.deleteDrawing();
      yield _yieldState(either, 'Failed to delete drawing from database.');
    } else if (event is ScreenOpened) {
      final either = await _drawingsRepositoryImpl.getDrawings(event.sketchId);
      yield _yieldState(either, 'Failed to fetch drawings from database.');
    }
    /*   else if (event is BackgroundColorChanged) {
      _drawingsRepositoryImpl
          .changeBackgroundColorOfCurrentDrawing(event.color);
    }*/
  }

  DrawingState _yieldState<A>(Either<Failure, A> either, String errorMessage) {
    return either.fold<DrawingState>(
        (fail) => _failure(errorMessage), (_) => _success());
  }

  DrawingState _failure(String message) => Error(
        currentDrawing: _drawingsRepositoryImpl.getCurrentDrawing(),
        previousDrawing: _drawingsRepositoryImpl.getPreviousDrawing(),
        message: message,
      );

  DrawingState _success() => DrawingLoaded(
        currentDrawing: _drawingsRepositoryImpl.getCurrentDrawing(),
        previousDrawing: _drawingsRepositoryImpl.getPreviousDrawing(),
      );
}
