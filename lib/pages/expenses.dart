import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/expense.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/expense.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

void main() => runApp(ExpensesPage());

class LocalController extends GetxController{
  bool _initial = true;
  final FadeInController controller = FadeInController();

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class ExpensesPage extends StatelessWidget {
  ExpensesPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => _getExpenses());

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: 'main',
      onPressed: () async {
        local.controller.fadeOut();
        await Navigator.pushNamed(context, Routes.newExpense);
        _getExpenses();
      },
      label: Text(PStrings.newExpenseFAB),
      icon: const Icon(Icons.account_balance_wallet),
    );

    return PLayout(
      title: PStrings.expenses,
      drawer: true,
      logoutConfirm: true,
      scrollable: true,
      onRefresh: () async => _getExpenses(),
      fab: fab,
      child: Obx(() => WidgetFromList(children: _main(global.expenses))),
    );
  }

  List<Widget> _main(List<Expense>? data) {
    if (data == null) return [];

    List<Widget> widgets = [];
    int pendings = 0;

    for (Expense expense in data) {
      if (!expense.accepted && expense.recipientId == global.userId) {
        pendings++;
      }

      widgets.add(ExpenseCard(
        expense: expense,
        refresh: _getExpenses,
        controller: local.controller,
      ));
    }

    global.updatePending(pendings);
    return widgets;
  }

  Future<void> _getExpenses() async {
    local.controller.fadeOut();
    Map map = await query(link: "expense", type: RequestType.get);

    if (map["success"]) {
      global.updateExpenses(expenseListFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.controller.fadeIn();
  }
}
