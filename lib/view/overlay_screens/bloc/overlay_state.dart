part of 'overlay_bloc.dart';

abstract class OverlayState extends Equatable {
  const OverlayState();

  @override
  List<Object> get props => [];
}

class OverlayInitial extends OverlayState {}

class OverlayEditSketchStarted extends OverlayState {}

class OverlaySuccess extends OverlayState {}

class OverlayLoading extends OverlayState {}

class OverlayError extends OverlayState {
  final String message;

  OverlayError(this.message);
}
