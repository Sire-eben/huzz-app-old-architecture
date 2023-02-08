import 'package:flutter/material.dart';

class UnfocusScope extends StatelessWidget {
  final Widget child;

  const UnfocusScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
