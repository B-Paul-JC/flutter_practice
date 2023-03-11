import 'package:flutter/material.dart';

void pushPage(
  BuildContext context, {
  required String next,
}) {
  Future.delayed(
    const Duration(milliseconds: 5000),
    () {
      if (next.isNotEmpty) {
        Navigator.of(context).pushNamed(
          next,
        );
      }
    },
  );
}
