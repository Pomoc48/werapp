import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/home_data.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/widgets/create_card.dart';

class MoneyRatio extends StatelessWidget {
  const MoneyRatio({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final GlobalController global = Get.find();

    Widget moneyIndicator(bool over, double factor) {
      TextTheme theme = Theme.of(context).textTheme.apply(
          bodyColor: PColors().surfaceVar(context));

      var line = Text("I", style: theme.bodyLarge);

      Row indicator(double factor, bool over) {
        MainAxisAlignment alignment = MainAxisAlignment.start;

        List<Widget> widgets = [
          const Flexible(child: FractionallySizedBox(widthFactor: 1)),
          Flexible(
            child: FractionallySizedBox(
              widthFactor: factor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: Settings.fullRadius,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: const SizedBox(height: 5),
              ),
            ),
          ),
        ];

        if (!over) {
          alignment = MainAxisAlignment.end;
          widgets = List<Widget>.from(widgets.reversed);
        }

        return Row(mainAxisAlignment: alignment, children: widgets);
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Widget>.generate(9, (index) => line),
          ),
          indicator(factor, over),
        ],
      );
    }

    Widget moneyRatio(MoneyMeter data) {
      User user = findUser(
        id: data.userId,
        userList: global.homeData!.users,
      );

      IconData? iconData() {
        if (data.winnerId == global.userId!) return Icons.arrow_drop_up;
        if (data.moneyLeft == 0) return null;
        return Icons.arrow_drop_down;
      }

      String leftMoney = "${formatDouble(data.moneyLeft, 2)} zł";
      if (data.moneyLeft == 0) leftMoney = "~";

      bool over = false;
      bool userWin = global.userId == data.winnerId;
      if (!data.tie) over = userWin;

      return InkWell(
        splashColor: PColors().inkWell(context),
        borderRadius: Settings.cardRadius,
        onTap: () async {
          await Navigator.pushNamed(context, Routes.newExpense);
          global.updateHomeData();
        },
        child: CreateCard(
          main: [
            Text(
              "with ${user.name}",
              style: PStyles().onSurface(context).bodyLarge,
            ),
            Row(
              children: [
                Icon(
                  iconData(),
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(leftMoney, style: PStyles().primary(context).bodyLarge),
              ],
            ),
          ],
          cont: moneyIndicator(over, data.factor),
        ),
      );
    }

    Widget moneyRatioList(HomeData? data) {
      List<Widget> widgets = [];

      if (data != null) {
        for (int i = 0; i < data.meters.length; i++) {
          widgets.add(moneyRatio(data.meters[i]));
          if (i != data.meters.length - 1) {
            widgets.add(SizedBox(height: Settings.pagePadding / 2));
          }
        }

        return Column(children: widgets);
      }

      return const SizedBox();
    }

    return Obx(() => moneyRatioList(global.homeData));
  }
}
