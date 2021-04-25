import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../painter_screen/drawing_bloc/drawing_bloc.dart';

import '../painter_screen/settings_bloc/settings_bloc.dart';

Future<void> showColorPicker(BuildContext context, Color currentPaintColor,
    {bool isForBackground = false}) {
  log('started');
  return showDialog(
    context: context,
    builder: (_) => ColorPickerWidget(
      currentColor: currentPaintColor,
      isForBackground: isForBackground,
    ),
  );
}

class ColorPickerWidget extends StatelessWidget {
  final Color currentColor;
  final bool isForBackground;

  ColorPickerWidget(
      {Key? key, required this.currentColor, this.isForBackground = false})
      : super(key: key);

  Color _selectedColor = Color(255);

  @override
  Widget build(BuildContext context) {
    _selectedColor = currentColor;
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          enableAlpha: false,
          pickerColor: currentColor,
          onColorChanged: (Color newColor) {
            _selectedColor = newColor;
          },
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Got it'),
          onPressed: () {
            if (isForBackground)
              BlocProvider.of<DrawingBloc>(context)
                  .add(BackgroundColorChanged(_selectedColor));
            else
              BlocProvider.of<SettingsBloc>(context).add(SettingsChanged(
                Paint()
                  ..color = _selectedColor
                  ..blendMode = BlendMode.srcOver,
              ));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
