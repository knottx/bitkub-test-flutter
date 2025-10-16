import 'dart:io';

import 'package:bitkub_test/domain/utils/app_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDialog {
  AppDialog._();

  static Future<void> error(
    BuildContext context,
    AppError error,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog.adaptive(
          title: const Text('Error'),
          content: Text(error.message),
          actions: [
            Platform.isIOS
                ? CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('OK'),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('OK'),
                  ),
          ],
        );
      },
    );
  }
}
