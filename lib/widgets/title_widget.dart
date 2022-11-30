import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({required this.child, required this.text, Key? key})
      : super(key: key);

  final Widget child;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Settings.pagePadding / 2),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
