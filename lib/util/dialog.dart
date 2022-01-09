import 'package:flutter/material.dart';

void showConfirmDialog(
    {required BuildContext context, @required VoidCallback? confirmTap}) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          'You want to logout?',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: Text(
                'No',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
            child: Text(
              'Yes',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              confirmTap!();
            },
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      );
    },
  );
}
