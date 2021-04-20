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

class EditSketch extends OverlayEvent {
  final Sketch editedSketch;

  EditSketch(this.editedSketch);
}

class DeleteSketch extends OverlayEvent {
  final String sketchId;

  DeleteSketch(this.sketchId);
}

class ExitOverlay extends OverlayEvent {
  final BuildContext context;

  ExitOverlay(this.context);
}
