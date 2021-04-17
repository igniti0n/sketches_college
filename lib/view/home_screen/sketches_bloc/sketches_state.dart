part of 'sketches_bloc.dart';

abstract class SketchesState extends Equatable {
  const SketchesState(this.sketches);
  final List<Sketch> sketches;
  @override
  List<Object> get props => [sketches];
}

class SketchesInitial extends SketchesState {
  SketchesInitial(List<Sketch> sketches) : super(sketches);
}

class SketchesLoaded extends SketchesState {
  SketchesLoaded(List<Sketch> sketches) : super(sketches);
}

class LoadingSketches extends SketchesState {
  LoadingSketches(List<Sketch> sketches) : super(sketches);
}

class Error extends SketchesState {
  final String message;
  Error(List<Sketch> sketches, this.message) : super(sketches);
}

class SketchSelected extends SketchesState {
  SketchSelected(List<Sketch> sketches) : super(sketches);
}
