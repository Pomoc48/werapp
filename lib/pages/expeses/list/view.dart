import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/expense.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/expeses/list/controller.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/expense.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class ExpensesPage extends StatelessWidget {
  ExpensesPage({super.key});

  final ExpensesController local = ExpensesController();

  @override
  Widget build(BuildContext context) {
    local.pageSetup();

    FloatingActionButton fab = FloatingActionButton.extended(
      heroTag: 'main',
      onPressed: () async => local.newExpense(),
      label: Text(PStrings.newExpenseFAB),
      icon: const Icon(Icons.account_balance_wallet),
    );

    return PLayout(
      title: PStrings.expenses,
      drawer: true,
      logoutConfirm: true,
      scrollable: true,
      onRefresh: () async => local.getExpenses(),
      fab: fab,
      fadeController: local.controller,
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(local.global.expenses),
      )),
    );
  }

  List<Widget> _main(List<Expense>? data) {
    if (data == null) return [];

    List<Widget> widgets = [];
    int pendings = 0;

    for (Expense expense in data) {
      if (!expense.accepted && expense.recipientId == local.global.userId) {
        pendings++;
      }

      widgets.add(ExpenseCard(
        expense: expense,
        refresh: local.getExpenses,
        controller: local.controller,
      ));
    }

    local.global.updatePending(pendings);
    return widgets;
  }
}
