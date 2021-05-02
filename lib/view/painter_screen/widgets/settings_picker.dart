import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/settings_menu_button.dart';
import '../../overlay_screens/overlay_bloc/overlay_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as sl;

import '../../../contants.dart';
import '../../../core/navigation/router.dart';
import '../settings_bloc/settings_bloc.dart';
import '../drawing_bloc/drawing_bloc.dart';

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
    final _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final _drawingBloc = BlocProvider.of<DrawingBloc>(context);
    final _overlayBloc = BlocProvider.of<OverlayBloc>(context);

    return BlocListener<DrawingBloc, DrawingState>(
      listener: (ctx, state) {
        if (state is Error)
          _overlayBloc
              .add(ShowErrorOverlay(context: ctx, message: state.message));
      },
      child: Container(
        color: medium,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (ctx, state) => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _settingsBloc.add(
                          SettingsChanged(
                            Paint()
                              ..blendMode = BlendMode.clear
                              ..color = state.paintSettings.color,
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.all(2),
                          alignment: Alignment.bottomRight,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(10, 255, 255, 255),
                              border: Border.all(
                                  color: state.paintSettings.blendMode ==
                                          BlendMode.clear
                                      ? purpleBar
                                      : Colors.white,
                                  width: 4)),
                          child: Placeholder(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _overlayBloc.add(ShowColorPicker(
                              currentColor: state.paintSettings.color,
                              context: context));
                        },
                        child: Container(
                          // width: double.infinity,
                          // height: double.infinity,

                          decoration: BoxDecoration(
                              color: state.paintSettings.color,
                              border: Border.all(
                                  color: state.paintSettings.blendMode ==
                                          BlendMode.clear
                                      ? Colors.white
                                      : purpleBar,
                                  width: 4)),
                        ),
                      ),
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
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 7,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 3,
                          child: StrokeSetting(),
                        ),
                        Flexible(
                          flex: 1,
                          child: SettingsMenuButton(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(SETTINGS_SCREEN_ROUTE),
                              icon: Icons.more_horiz,
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
                          child: SettingsMenuButton(
                              onTap: () {
                                _drawingBloc.add(DuplicateDrawing(context));
                              },
                              icon: Icons.control_point_duplicate,
                              splashColor: purpleBar),
                        ),
                        Expanded(
                          child: SettingsMenuButton(
                              onTap: () => _overlayBloc.add(
                                  ShowDeleteDrawingOverlay(context: context)),
                              icon: Icons.remove_circle_outline,
                              splashColor: purpleBar),
                        ),
                        Expanded(
                          child: SettingsMenuButton(
                              onTap: () => _drawingBloc.add(
                                    Undo(),
                                  ),
                              icon: Icons.replay_outlined,
                              splashColor: purpleBar),
                        ),
                        Expanded(
                          child: SettingsMenuButton(
                              onTap: () =>
                                  _drawingBloc.add(ScreenExit(context)),
                              icon: Icons.exit_to_app,
                              splashColor: purpleBar),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          // log(newStrokeWidth.toString());
          setState(() => _currentSliderValue = newStrokeWidth);
          _settingsBloc.add(SettingsStrokeWidthChanged(_currentSliderValue));
        });
  }
}
