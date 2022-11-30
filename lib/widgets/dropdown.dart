import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/padding.dart';

class PDropdown extends StatelessWidget {
  const PDropdown({
    Key? key,
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
  }): super(key: key);

  final String title;
  final List<DropdownMenuItem>? items;
  final dynamic value;
  final void Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PPadding(
          widget: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Expanded(
          child: Card(
            child: DropdownButton(
              isExpanded: true,
              elevation: 0,
              itemHeight: 56,
              iconSize: 32,
              borderRadius: PRadius.card,
              dropdownColor: PColors().surfaceVar(context),
              underline: Container(height: 0, color: Colors.transparent),
              items: items,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

DropdownMenuItem<int> dropdownMenuItem(int id, String name) {
  return DropdownMenuItem<int>(
    value: id,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(name),
    ),
  );
}