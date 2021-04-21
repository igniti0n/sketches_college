part of 'overlay_bloc.dart';

abstract class OverlayState extends Equatable {
  const OverlayState();

  @override
  List<Object> get props => [];
}

class OverlayInitial extends OverlayState {}

//!editing sketch states
class OverlayEditSketchStarted extends OverlayState {}

class OverlayDeleteSketchStarted extends OverlayState {}

//!Color picker
class OverlayColorPickerStarted extends OverlayState {}

//!Overlay progress states
class OverlaySuccess extends OverlayState {
  final String message;

  OverlaySuccess(this.message);
}

class OverlayLoading extends OverlayState {}

class OverlayError extends OverlayState {
  final String message;

  OverlayError(this.message);
}
