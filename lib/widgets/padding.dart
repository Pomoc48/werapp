import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class PPadding extends StatelessWidget {
  const PPadding({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Settings.pagePadding),
      child: widget,
    );
  }
}
