part of 'animation_bloc.dart';

abstract class AnimationEvent extends Equatable {
  const AnimationEvent();

  @override
  List<Object> get props => [];
}

class ChangeFrame extends AnimationEvent {
  final Drawing drawing;

  ChangeFrame(this.drawing);
}

class ScreenStarted extends AnimationEvent {}

class ScreenExited extends AnimationEvent {
  final BuildContext context;

  ScreenExited(this.context);
}

class ChangeFps extends AnimationEvent {
  final double fps;

  ChangeFps(this.fps);
}
