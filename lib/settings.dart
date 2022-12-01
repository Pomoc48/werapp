import 'package:flutter/material.dart';

class Settings {
  static double pagePadding = 16;

  static BoxConstraints actionConstraint = const BoxConstraints(
    minWidth: 56,
    minHeight: 56,
  );

  static UnderlineInputBorder noBorder = const UnderlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),
  );

  static BorderRadius cardRadius = BorderRadius.circular(12);
  static BorderRadius fullRadius = BorderRadius.circular(999);
}

class PStyles {
  TextTheme onSurface(BuildContext context) {
    return Theme.of(context).textTheme.apply(
        displayColor: Theme.of(context).colorScheme.onSurface,
        bodyColor: Theme.of(context).colorScheme.onSurface);
  }

  TextTheme primary(BuildContext context) {
    return Theme.of(context).textTheme.apply(
        displayColor: Theme.of(context).colorScheme.primary,
        bodyColor: Theme.of(context).colorScheme.primary);
  }
}

class PColors {
  Color surfaceVar(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceVariant;
  }

  Color onSecondaryC(BuildContext context) {
    return Theme.of(context).colorScheme.onSecondaryContainer;
  }

  /// InkWell's splash color
  Color inkWell(BuildContext context) {
    return Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.25);
  }
}

class Routes {
  static String login = '/';
  static String setup = '/setup';
  static String home = '/home';
  static String commandsLog = '/commands';
  static String newCommand = '/new-command';
  static String stats = '/stats';
  static String expenses = '/expenses';
  static String newExpense = '/new-expense';
  static String charts = '/charts';
  static String events = '/events';
  static String newEvent = '/new-event';
  static String detailEvent = '/detail-event';
  static String priceList = '/price-list';
  static String newPriceList = '/new-price-list';
  static String newUser = '/new-user';
  static String settings = '/settings';
}
