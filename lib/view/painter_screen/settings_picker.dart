import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../options_screen/widgets/settings_menu_button.dart';
import '../overlay_screens/overlay_bloc/overlay_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as sl;

import '../../contants.dart';
import '../../core/navigation/router.dart';
import 'settings_bloc/settings_bloc.dart';
import 'drawing_bloc/drawing_bloc.dart';

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
      color: medium,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 7,
                  child: StrokeSetting(),
                ),
                Flexible(
                  flex: 1,
                  child: SettingsMenuButton(
                      onTap: () => Navigator.of(context)
                          .pushNamed(SETTINGS_SCREEN_ROUTE),
                      text: '....',
                      splashColor: purpleBar),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () => BlocProvider.of<OverlayBloc>(context).add(
                            ShowColorPicker(
                                currentColor: state.paintSettings.color,
                                context: context)),
                        child: Container(
                          decoration: BoxDecoration(
                              color: state.paintSettings.color,
                              border: Border.all(color: Colors.white)),
                        ),
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
                  child: SettingsMenuButton(
                      onTap: () => BlocProvider.of<SettingsBloc>(context).add(
                            SettingsChanged(
                              Paint()..blendMode = BlendMode.clear,
                              // Paint()..color = Colors.white,
                            ),
                          ),
                      text: 'Erase',
                      splashColor: purpleBar),
                ),
                Expanded(
                  child: SettingsMenuButton(
                      onTap: () => BlocProvider.of<DrawingBloc>(context)
                          .add(DuplicateDrawing()),
                      text: 'Dup',
                      splashColor: purpleBar),
                ),
                Expanded(
                  child: SettingsMenuButton(
                      onTap: () => BlocProvider.of<DrawingBloc>(context)
                          .add(DeleteDrawing()),
                      text: 'Del',
                      splashColor: purpleBar),
                ),
                Expanded(
                  child: SettingsMenuButton(
                      onTap: () => BlocProvider.of<DrawingBloc>(context).add(
                            Undo(),
                          ),
                      text: 'Undo',
                      splashColor: purpleBar),
                ),
                Expanded(
                  child: SettingsMenuButton(
                      onTap: () => BlocProvider.of<DrawingBloc>(context).add(
                            NextDrawing(),
                          ),
                      text: 'Next',
                      splashColor: purpleBar),
                ),
                Expanded(
                  child: SettingsMenuButton(
                      onTap: () => BlocProvider.of<DrawingBloc>(context).add(
                            PreviousDrawing(),
                          ),
                      text: 'Prev',
                      splashColor: purpleBar),
                ),
                Expanded(
                  child: SettingsMenuButton(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(HOME_SCREEN_ROUTE),
                      text: 'Back',
                      splashColor: purpleBar),
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
