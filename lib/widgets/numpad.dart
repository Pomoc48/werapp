import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/padding.dart';

class Numpad extends StatelessWidget {
  const Numpad({
    Key? key,
    required this.inputClear,
    required this.buttonInput,
  }) : super(key: key);

  final void Function() inputClear;
  final void Function(String) buttonInput;

  final double margin = 10;
  final double size = 70;


  @override
  Widget build(BuildContext context) {
    Widget buttonPIN(String number) {
      return SizedBox(
        height: size,
        width: size,
        child: TextButton(
          onPressed: () => buttonInput(number),
          child: Text(number, style: PStyles().onSurface(context).headlineSmall),
        ),
      );
    }

    Widget clear() {
      return SizedBox(
        height: size,
        width: size,
        child: TextButton(
          onPressed: () => inputClear(),
          child: Icon(
            Icons.clear,
            size: 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    List<Widget> w = [];

    for (int i = 0; i < 4; i++) {
      if (i != 3) {
        int row = i * 3;
        w.addAll([
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonPIN((row + 1).toString()),
              SizedBox(width: margin),
              buttonPIN((row + 2).toString()),
              SizedBox(width: margin),
              buttonPIN((row + 3).toString()),
            ],
          ),
          SizedBox(height: margin),
        ]);
      } else {
        w.addAll([
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: margin + size),
              buttonPIN("0"),
              SizedBox(width: margin),
              clear(),
            ],
          ),
        ]);
      }
    }

    return PPadding(
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: w,
      ),
    );
  }
}
