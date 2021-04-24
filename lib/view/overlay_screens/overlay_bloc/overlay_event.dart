part of 'overlay_bloc.dart';

abstract class OverlayEvent extends Equatable {
  const OverlayEvent();

  @override
  List<Object> get props => [];
}

//!edit sketch overlay
class ShowEditOverlay extends OverlayEvent {
  final Sketch sketch;
  final BuildContext context;

  ShowEditOverlay({
    required this.sketch,
    required this.context,
  });
}

class ShowDeleteOverlay extends OverlayEvent {
  final Sketch sketch;
  final BuildContext context;

  ShowDeleteOverlay({
    required this.sketch,
    required this.context,
  });
}

class ShowErrorOverlay extends OverlayEvent {
  final String message;
  final BuildContext context;

  ShowErrorOverlay({
    required this.context,
    required this.message,
  });
}

class ShowColorPicker extends OverlayEvent {
  final Color currentColor;
  final BuildContext context;
  final bool isForBackground;

  ShowColorPicker({
    required this.currentColor,
    required this.context,
    this.isForBackground = false,
  });
}

class EditSketch extends OverlayEvent {
  final String name;
  final String id;

  EditSketch(this.name, this.id);
}

class DeleteSketch extends OverlayEvent {
  final String sketchId;

  DeleteSketch(this.sketchId);
}

class ExitOverlay extends OverlayEvent {
  final BuildContext context;

  ExitOverlay(this.context);
}
