import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:paint_app/view/painter_screen/drawing_navigation_bloc/navigation_bloc.dart';
import '../../../core/navigation/router.dart';
import '../../../core/error/failures.dart';
import '../../../domain/repositories/drawings_repository.dart';
import '../../../domain/entities/drawing.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final DrawingsRepository _drawingsRepositoryImpl;

  late final StreamSubscription _navigationSubscription;
  final DrawingNavigationBloc _drawingNavigationBloc;
  DrawingBloc(this._drawingsRepositoryImpl, this._drawingNavigationBloc)
      : super(
          DrawingInitial(
              currentDrawing: Drawing(canvasPaths: [], sketchId: '', id: ''),
              previousDrawing: Drawing(canvasPaths: [], sketchId: '', id: '')),
        ) {
    _navigationSubscription = _drawingNavigationBloc.stream.listen((state) {
      if (state is DrawingChanged) this.add(RefreshScreen());
    });
  }

  @override
  Future<void> close() {
    _navigationSubscription.cancel();
    return super.close();
  }

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
    } else if (event is DuplicateDrawing) {
      final either = await _drawingsRepositoryImpl.duplicateDrawing();
      _drawingNavigationBloc.add(Refresh());
      yield _yieldState(either, 'Failed to duplicate the drawing.');
    } else if (event is ScreenOpened) {
      final either = await _drawingsRepositoryImpl.getDrawings(event.sketchId);
      _drawingNavigationBloc.add(Refresh());
      yield _yieldState(either, 'Failed to fetch drawings from database.');
    } else if (event is RefreshScreen) {
      yield _success();
    } else if (event is ScreenExit) {
      final either = await _drawingsRepositoryImpl.saveDrawing();
      if (either.isRight())
        Navigator.of(event.context).pushReplacementNamed(HOME_SCREEN_ROUTE);

      yield _yieldState(either, 'Failed to save drawing.');
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
