part of 'animation_bloc.dart';

abstract class AnimationState extends Equatable {
  const AnimationState(this.drawingToShow);
  final Drawing drawingToShow;

  @override
  List<Object> get props => [drawingToShow];
}

class AnimationInitial extends AnimationState {
  AnimationInitial(Drawing drawingToShow) : super(drawingToShow);
}

class DrawingPresented extends AnimationState {
  DrawingPresented(Drawing drawingToShow) : super(drawingToShow);
}
