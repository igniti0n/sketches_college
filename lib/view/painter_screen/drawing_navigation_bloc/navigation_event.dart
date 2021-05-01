part of 'navigation_bloc.dart';

abstract class DrawingNavigationEvent extends Equatable {
  const DrawingNavigationEvent();

  @override
  List<Object> get props => [];
}

class PreviousDrawing extends DrawingNavigationEvent {}

class NextDrawing extends DrawingNavigationEvent {}

class LastDrawing extends DrawingNavigationEvent {}

class FirstDrawing extends DrawingNavigationEvent {}

class Refresh extends DrawingNavigationEvent {}
