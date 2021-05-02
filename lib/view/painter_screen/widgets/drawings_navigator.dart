import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/settings_menu_button.dart';
import '../../overlay_screens/overlay_bloc/overlay_bloc.dart';
import '../drawing_navigation_bloc/navigation_bloc.dart';

import '../../../contants.dart';

class DrawingsNavigator extends StatelessWidget {
  const DrawingsNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _drawingBloc = BlocProvider.of<DrawingNavigationBloc>(context);
    final _overlayBloc = BlocProvider.of<OverlayBloc>(context);
    final TextStyle _textStyle = Theme.of(context).textTheme.bodyText1!;

    return Container(
      color: medium,
      height: _size.height * 0.1,
      width: double.infinity,
      child: BlocConsumer<DrawingNavigationBloc, DrawingNavigationState>(
        listener: (ctx, state) {
          if (state is Error)
            _overlayBloc
                .add(ShowErrorOverlay(context: ctx, message: state.message));
        },
        builder: (context, state) {
          return Row(children: [
            Expanded(
              child: SettingsMenuButton(
                  onTap: () => _drawingBloc.add(
                        FirstDrawing(),
                      ),
                  icon: Icons.skip_previous_rounded,
                  splashColor: purpleBar),
            ),
            Expanded(
              child: SettingsMenuButton(
                  onTap: () => _drawingBloc.add(
                        PreviousDrawing(),
                      ),
                  icon: Icons.undo_rounded,
                  splashColor: purpleBar),
            ),
            Expanded(
              child: SettingsMenuButton(
                  onTap: () => _drawingBloc.add(
                        NextDrawing(),
                      ),
                  icon: Icons.redo_rounded,
                  splashColor: purpleBar),
            ),
            Expanded(
              child: SettingsMenuButton(
                  onTap: () => _drawingBloc.add(
                        LastDrawing(),
                      ),
                  icon: Icons.skip_next_rounded,
                  splashColor: purpleBar),
            ),
            Expanded(
              child: AutoSizeText(
                state.pageNumber.toString() +
                    '  /  ' +
                    state.maxPage.toString(),
                style: _textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
