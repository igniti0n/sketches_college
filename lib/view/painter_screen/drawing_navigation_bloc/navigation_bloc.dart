import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../domain/repositories/drawings_repository.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

const String ERROR_UPDATE_DRAWING = 'Failed to update drawing.';

class DrawingNavigationBloc
    extends Bloc<DrawingNavigationEvent, DrawingNavigationState> {
  final DrawingsRepository _drawingsRepositoryImpl;
  DrawingNavigationBloc(this._drawingsRepositoryImpl)
      : super(NavigationInitial(0, _drawingsRepositoryImpl.maxPage));

  @override
  Stream<DrawingNavigationState> mapEventToState(
    DrawingNavigationEvent event,
  ) async* {
    yield NavigationInitial(
        _drawingsRepositoryImpl.currentPage, _drawingsRepositoryImpl.maxPage);

    if (event is PreviousDrawing) {
      final either = await _drawingsRepositoryImpl.previousDrawing();
      yield _yieldState(
          either, ERROR_UPDATE_DRAWING, _drawingsRepositoryImpl.currentPage);
    } else if (event is NextDrawing) {
      final either = await _drawingsRepositoryImpl.nextDrawing();

      yield _yieldState(
          either, ERROR_UPDATE_DRAWING, _drawingsRepositoryImpl.currentPage);
    } else if (event is FirstDrawing) {
      final either = await _drawingsRepositoryImpl.firstDrawing();
      yield _yieldState(
          either, ERROR_UPDATE_DRAWING, _drawingsRepositoryImpl.currentPage);
    } else if (event is LastDrawing) {
      final either = await _drawingsRepositoryImpl.lastDrawing();
      yield _yieldState(
          either, ERROR_UPDATE_DRAWING, _drawingsRepositoryImpl.currentPage);
    } else if (event is Refresh) {
      yield NavigationInitial(
          _drawingsRepositoryImpl.currentPage, _drawingsRepositoryImpl.maxPage);
      yield _success(_drawingsRepositoryImpl.currentPage);
    }
  }

  DrawingNavigationState _yieldState<A>(
      Either<Failure, A> either, String errorMessage, int page) {
    return either.fold<DrawingNavigationState>(
        (fail) => _failure(errorMessage, page), (_) => _success(page));
  }

  DrawingNavigationState _failure(String message, int page) =>
      Error(message, page, _drawingsRepositoryImpl.maxPage);

  DrawingNavigationState _success(int page) =>
      DrawingChanged(page, _drawingsRepositoryImpl.maxPage);
}
