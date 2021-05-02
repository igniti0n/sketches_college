import 'package:flutter/material.dart' hide OverlayState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state_views.dart';
import '../painter_screen/drawing_bloc/drawing_bloc.dart';
import '../painter_screen/drawing_navigation_bloc/navigation_bloc.dart';
import '../../contants.dart';
import '../../core/widgets/settings_menu_button.dart';

import 'overlay_bloc/overlay_bloc.dart';

Future<void> showDeleteDrawingDialog(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (_) => DeleteDrawingDialogWidget(),
  );
}

class DeleteDrawingDialogWidget extends StatelessWidget {
  DeleteDrawingDialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverlayBloc, OverlayState>(
      builder: (ctx, state) {
        if (state is OverlayLoading) {
          return loadingView(ctx);
        } else if (state is OverlayError) {
          return outcomeView(
            context,
            state.message,
            () {
              BlocProvider.of<OverlayBloc>(context).add(ExitOverlay(context));
            },
          );
        } else if (state is OverlaySuccess) {
          return outcomeView(
            context,
            state.message,
            () {
              BlocProvider.of<OverlayBloc>(context).add(ExitOverlay(context));
              BlocProvider.of<DrawingBloc>(context).add(RefreshScreen());
              BlocProvider.of<DrawingNavigationBloc>(context).add(Refresh());
            },
          );
        } else if (state is OverlayDeleteSketchStarted) {
          return _delete(ctx);
        }
        return Container();
      },
    );
  }
}

SimpleDialog _delete(BuildContext ctx) {
  return SimpleDialog(
    backgroundColor: overlayBackground,
    title: Text("Delete current drawing?"),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SettingsMenuButton(
            onTap: () => BlocProvider.of<OverlayBloc>(ctx).add(DeleteDrawing()),
            splashColor: purpleBar,
            contentColor: Colors.red.withAlpha(170),
            text: 'delete',
          ),
          SettingsMenuButton(
            onTap: () => Navigator.of(ctx).pop(),
            splashColor: purpleBar,
            text: 'Keep',
          ),
        ],
      ),
    ],
  );
}
