import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/expense.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/profile_avatar.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    Key? key,
    required this.expense,
    required this.refresh,
    required this.controller,
  }) : super(key: key);

  final Expense? expense;
  final FadeInController controller;
  final void Function() refresh;

  @override
  Widget build(BuildContext context) {
    final GlobalController global = Get.find();

    List<Widget> expenseTitle(Expense expense) {
      List<Widget> widgets = [
        ProfileAvatar(
          userId: expense.userId,
          timestamp: expense.timestamp,
        ),
      ];

      var verified = OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check),
        label: Text(PStrings.verified),
      );

      if (global.userId! == expense.userId) {
        if (expense.accepted) {
          widgets.add(verified);
        } else {
          widgets.add(
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(PStrings.dialogAlert),
                      content: Text(PStrings.removeConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(PStrings.no),
                        ),
                        TextButton(
                          onPressed: () async {
                            controller.fadeOut();
                            Map map = await expense.remove();
                          
                            Get.back();
                            snackBar(Get.context!, map["message"]);
                            refresh();
                          },
                          child: Text(PStrings.yes),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
              label: Text(PStrings.delete),
          ));
        }
      } else {
        if (expense.accepted) {
          widgets.add(verified);
        } else {
          widgets.add(
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(PStrings.dialogAlert),
                      content: Text(PStrings.verifyConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(PStrings.no),
                        ),
                        TextButton(
                          onPressed: () async {
                            controller.fadeOut();
                            Map map = await expense.verify();

                            Get.back();
                            snackBar(Get.context!, map["message"]);
                            refresh();
                          },
                          child: Text(PStrings.yes),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.check),
              label: Text(PStrings.accept),
          ));
        }
      }
      return widgets;
    }

    if (expense != null) {
      String moneyFormat = "${formatDouble(expense!.money, 2)} zł";

      String uName = findUser(
        id: expense!.recipientId,
        userList: global.homeData!.users,
      ).name;

      if (expense!.gift) {
        moneyFormat = "${PStrings.expenseGift} ($moneyFormat) for $uName";
      } else {
        moneyFormat = "${PStrings.moneyCombined} ($moneyFormat) with $uName";
      }

      if (expense!.description != "") {
        return CreateCard(
          main: expenseTitle(expense!),
          cont: [moneyFormat, expense!.description!],
        );
      }

      return CreateCard(
        main: expenseTitle(expense!),
        cont: [moneyFormat],
      );
    }

    else {
      return InkWell(
        splashColor: PColors().inkWell(context),
        borderRadius: Settings.cardRadius,
        onTap: () async {
          controller.fadeOut();
          await Get.toNamed(Routes.newExpense);
          refresh();
        },
        child: CreateCard(
          main: [PStrings.noRecentExpenses],
          cont: [PStrings.newExpense],
        ),
      );
    }
  }
}
