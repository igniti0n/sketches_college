import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'overlay_bloc/overlay_bloc.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String message,
) {
  return showDialog(
    context: context,
    builder: (_) => ErrorDialogWidget(
      message: message,
    ),
  );
}

class ErrorDialogWidget extends StatelessWidget {
  final String message;

  ErrorDialogWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error occured!'),
      content: SingleChildScrollView(
        child: Text('Unfortunatelly, \n' + message),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Got it'),
          onPressed: () {
            BlocProvider.of<OverlayBloc>(context).add(ExitOverlay(context));
          },
        ),
      ],
    );
  }
}
