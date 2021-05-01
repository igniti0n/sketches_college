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

class ScreenExit extends DrawingEvent {
  final BuildContext context;

  ScreenExit(this.context);
}

class RefreshScreen extends DrawingEvent {}

//!drawing actions
class SaveDrawing extends DrawingEvent {}

class DuplicateDrawing extends DrawingEvent {}

// class DeleteDrawing extends DrawingEvent {}

class Undo extends DrawingEvent {}

class BackgroundColorChanged extends DrawingEvent {
  final Color color;

  BackgroundColorChanged(this.color);
}

//!press, drag and let go of screen
class EndDrawing extends DrawingEvent {}

class UpdateDrawing extends DrawingEvent {
  final Offset offset;
  const UpdateDrawing(this.offset);
}

class StartDrawing extends DrawingEvent {
  final Offset offset;
  final Paint paint;
  const StartDrawing({
    required this.offset,
    required this.paint,
  });
}
