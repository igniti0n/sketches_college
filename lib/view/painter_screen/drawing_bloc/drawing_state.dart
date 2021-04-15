part of 'drawing_bloc.dart';

abstract class DrawingState extends Equatable {
  const DrawingState(
      {required this.currentDrawing, required this.previousDrawing});
  final Drawing currentDrawing;
  final Drawing previousDrawing;

  @override
  List<Object> get props => [currentDrawing, previousDrawing];
}

class DrawingInitial extends DrawingState {
  DrawingInitial(
      {required Drawing currentDrawing, required Drawing previousDrawing})
      : super(
          currentDrawing: currentDrawing,
          previousDrawing: previousDrawing,
        );
}

class DrawingLoading extends DrawingState {
  DrawingLoading(
      {required Drawing currentDrawing, required Drawing previousDrawing})
      : super(
          currentDrawing: currentDrawing,
          previousDrawing: previousDrawing,
        );
}

class DrawingLoaded extends DrawingState {
  DrawingLoaded(
      {required Drawing currentDrawing, required Drawing previousDrawing})
      : super(
          currentDrawing: currentDrawing,
          previousDrawing: previousDrawing,
        );
}
