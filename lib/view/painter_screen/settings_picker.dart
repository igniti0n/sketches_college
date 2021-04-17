import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_app/core/navigation/router.dart';
import 'package:paint_app/view/home_screen/sketches_bloc/sketches_bloc.dart';
import 'package:paint_app/view/painter_screen/drawing_bloc/drawing_bloc.dart';
import 'package:paint_app/view/settings_screen/settings_bloc/settings_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as sl;

class SettingsPicker extends StatefulWidget {
  SettingsPicker({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPickerState createState() => _SettingsPickerState();
}

class _SettingsPickerState extends State<SettingsPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: StrokeSetting(),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return ColorPickerWidget(
                        currentColor: state.paintSettings.color,
                      );
                    },
                  ),

                  //  TextButton(
                  //   onPressed: () => BlocProvider.of<SettingsBloc>(context).add(
                  //     SettingsChanged(
                  //       Paint()
                  //         ..color = Colors.red
                  //         ..blendMode = BlendMode.srcOver,
                  //     ),
                  //   ),
                  //   child: Text('crvena'),
                  // ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => BlocProvider.of<SettingsBloc>(context).add(
                      SettingsChanged(
                        Paint()..blendMode = BlendMode.clear,
                      ),
                    ),
                    child: Text('erase'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      BlocProvider.of<DrawingBloc>(context)
                          .add(DuplicateDrawing());
                    },
                    child: Text('dup'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      BlocProvider.of<DrawingBloc>(context)
                          .add(DeleteDrawing());
                    },
                    child: Text('del'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => BlocProvider.of<DrawingBloc>(context).add(
                      Undo(),
                    ),
                    child: Text('Undo'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => BlocProvider.of<DrawingBloc>(context).add(
                      NextDrawing(),
                    ),
                    child: Text('next'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => BlocProvider.of<DrawingBloc>(context).add(
                      PreviousDrawing(),
                    ),
                    child: Text('prev'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () =>

                        // BlocProvider.of<SketchesBloc>(context)
                        //     .add(SettingsStrokeWidthChanged(20));
                        Navigator.of(context)
                            .pushReplacementNamed(HOME_SCREEN_ROUTE),
                    child: Text('back'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StrokeSetting extends StatefulWidget {
  StrokeSetting({Key? key}) : super(key: key);

  @override
  _StrokeSettingState createState() => _StrokeSettingState();
}

class _StrokeSettingState extends State<StrokeSetting> {
  double _currentSliderValue = 2.0;
  @override
  Widget build(BuildContext context) {
    final _settingsBloc = BlocProvider.of<SettingsBloc>(context, listen: false);
    return sl.SfSlider.vertical(
        value: _currentSliderValue,
        stepSize: 1,
        min: 1.0,
        max: 44.0,
        enableTooltip: true,
        tooltipPosition: sl.SliderTooltipPosition.right,
        interval: 44,
        onChanged: (newStrokeWidth) {
          log(newStrokeWidth.toString());
          setState(() => _currentSliderValue = newStrokeWidth);
          _settingsBloc.add(SettingsStrokeWidthChanged(_currentSliderValue));
        });
  }
}

class ColorPickerWidget extends StatelessWidget {
  final Color currentColor;

  ColorPickerWidget({Key? key, required this.currentColor}) : super(key: key);

  Color _selectedColor = Color(255);

  @override
  Widget build(BuildContext context) {
    _selectedColor = currentColor;
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
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
                BlocProvider.of<SettingsBloc>(context).add(SettingsChanged(
                  Paint()
                    ..color = _selectedColor
                    ..blendMode = BlendMode.srcOver,
                ));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.white),
          color: currentColor,
        ),
      ),
    );
  }
}
