part of 'sketches_bloc.dart';

abstract class SketchesState extends Equatable {
  const SketchesState();
  
  @override
  List<Object> get props => [];
}

class SketchesInitial extends SketchesState {}
