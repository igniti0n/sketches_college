import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_event.dart';
part 'settings_state.dart';

final Paint defaultPaint = Paint()
  ..color = Colors.pink
  ..strokeWidth = 4;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  Paint _currentPaint = defaultPaint;
  SettingsBloc() : super(SettingsInitial(defaultPaint));

  Paint _paintFrom(Paint paint) {
    return Paint()
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
      ..blendMode = paint.blendMode
      ..strokeCap = paint.strokeCap
      ..shader = paint.shader;
  }

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    //log("SETTINGS event:" + event.toString());
    if (event is SettingsChanged) {
      // yield SettingsLoading(_currentPaint);
      _currentPaint = _paintFrom(event.paint)
        ..strokeWidth = _currentPaint.strokeWidth;
      yield SettingsLoaded(_currentPaint);
    } else if (event is SettingsStrokeWidthChanged) {
      // if (_currentPaint.strokeWidth + event.strokeWidth != 0)
      _currentPaint..strokeWidth = event.strokeWidth;
      // yield SettingsLoading(_currentPaint);
      yield SettingsLoaded(_currentPaint);
    }
    // else if (event is SettingsColorChanged) {
    //   _currentPaint..color = event.color;
    //   yield SettingsLoading(_currentPaint);
    //   yield SettingsLoaded(_currentPaint);
    // }
  }
}
