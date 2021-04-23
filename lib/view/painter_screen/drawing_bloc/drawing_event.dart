part of 'drawing_bloc.dart';

abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object> get props => [];
}

class ScreenOpened extends DrawingEvent {
  final String sketchId;

  ScreenOpened(this.sketchId);
}

class SaveDrawing extends DrawingEvent {}

class PreviousDrawing extends DrawingEvent {}

class NextDrawing extends DrawingEvent {}

class DuplicateDrawing extends DrawingEvent {}

class DeleteDrawing extends DrawingEvent {}

class Undo extends DrawingEvent {}

class BackgroundColorChanged extends DrawingEvent {
  final Color color;

  BackgroundColorChanged(this.color);
}

class UpdateDrawing extends DrawingEvent {
  final CanvasPath canvasPath;
  const UpdateDrawing(this.canvasPath);
}

class StartDrawing extends DrawingEvent {
  final CanvasPath canvasPath;
  const StartDrawing(this.canvasPath);
}
