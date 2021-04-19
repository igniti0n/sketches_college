part of 'sketches_bloc.dart';

abstract class SketchesEvent extends Equatable {
  const SketchesEvent();

  @override
  List<Object> get props => [];
}

class FetchAllSketches extends SketchesEvent {}

class AddNewSketch extends SketchesEvent {}

class EditSketch extends SketchesEvent {
  final Sketch editedSketch;

  EditSketch(this.editedSketch);
}

class DeleteSketch extends SketchesEvent {}

class FetchSketch extends SketchesEvent {
  final String sketchId;

  FetchSketch(this.sketchId);
}
