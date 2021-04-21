import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'options_event.dart';
part 'options_state.dart';

class OptionsBloc extends Bloc<OptionsEvent, OptionsState> {
  OptionsBloc() : super(OptionsInitial());

  @override
  Stream<OptionsState> mapEventToState(
    OptionsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
