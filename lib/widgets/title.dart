import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class PTitle extends StatelessWidget {
  const PTitle({super.key, required this.message, this.noHorizontal});

  final String message;
  final bool? noHorizontal;

  @override
  Widget build(BuildContext context) {
    double horizontal = noHorizontal != null ? 0 : 16;
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: horizontal,
        ),
        child: Text(
          message,
          style: PStyles().onSurface(context).headlineMedium,
        ),
      ),
    );
  }
}
