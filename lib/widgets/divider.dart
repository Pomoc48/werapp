import 'package:flutter/material.dart';

class PDivider extends StatelessWidget {
  const PDivider({
    Key? key,
    this.indent = 0,
    this.height = 2,
  }) : super(key: key);

  final double? indent;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      indent: indent,
      endIndent: indent,
      thickness: 1,
    );
  }
}
