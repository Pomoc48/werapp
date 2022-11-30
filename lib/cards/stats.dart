import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/create_card.dart';
import 'package:wera_f2/widgets/divider.dart';
import 'package:wera_f2/widgets/padding.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    Key? key,
    required this.mapList,

  }) : super(key: key);

  final List<List> mapList;

  @override
  Widget build(BuildContext context) {
    final GlobalController global = Get.find();

    Widget statsCardUsers(List<List> mapList) {
      TextStyle? bodyLarge = PStyles().onSurface(context).bodyLarge;
      TextStyle? primary = PStyles().primary(context).bodyLarge;

      List<Widget> widgets = [];

      for (int i = 0; i < mapList.length; i++) {
        String value;
        if (mapList[i][1] is double) {
          value = "${formatDouble(mapList[i][1], 2)} zł";
        } else {
          value = mapList[i][1].toString();
        }

        User user = findUser(
          id: mapList[i][0],
          userList: global.homeData!.users,
        );

        widgets.add(Row(children: [
          Expanded(
            child: PPadding( widget: Text(user.name, style: bodyLarge)),
          ),
          PPadding(widget: Text(value, style: primary))
        ]));

        if (i != mapList.length - 1) {
          widgets.add(PDivider(indent: Settings.pagePadding));
        }
      }

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      );
    }

    Widget statsCardCombined(List<List> values) {
      num sum = 0;
      for (int i = 0; i < values.length; i++) {
        sum += values[i][1];
      }
      if (values[0][1] is double) {
        return CreateCard(
          main: [PStrings.statsTotal, "${formatDouble(sum.toDouble(), 2)} zł"],
        );
      } else {
        return CreateCard(main: [PStrings.statsTotal, sum.toString()]);
      }
    }

    return Column(
      children: [
        statsCardUsers(mapList),
        SizedBox(height: Settings.pagePadding / 2),
        statsCardCombined(mapList),
      ],
    );
  }
}
