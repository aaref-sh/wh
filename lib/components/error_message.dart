import 'package:flutter/material.dart';

showErrorMessage(BuildContext context, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("حسناً"),
    onPressed: () => Navigator.pop(context),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(message),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
