part of 'options_bloc.dart';

abstract class OptionsState extends Equatable {
  const OptionsState();
  
  @override
  List<Object> get props => [];
}

class OptionsInitial extends OptionsState {}
