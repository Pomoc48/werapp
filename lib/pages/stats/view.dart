import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/stats_data.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/stats/controller.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/stats.dart';
import 'package:wera_f2/widgets/title_widget.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

enum StatsType {
  totalPoints,
  usedCommands,
  usedPoints,
  giftedMoney,
  transactions,
}

class StatsPage extends StatelessWidget {
  StatsPage({super.key});

  final StatsController local = StatsController();

  @override
  Widget build(BuildContext context) {
    local.pageSetup();

    return PLayout(
      title: PStrings.stats,
      drawer: true,
      scrollable: true,
      logoutConfirm: true,
      fadeController: local.controller,
      onRefresh: () async => local.getStats(),
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(local.global.stats),
      )),
    );
  }

  List<Widget> _main(List<StatsData>? data) {
    if (data == null) return [];

    List<Widget> stats = [];
    for (var value in StatsType.values) {
      stats.add(_statType(value));
    }

    return stats;
  }

  Widget _statType(StatsType type) {
    List<List> mapList = [];
    String title;

    switch (type) {
      case StatsType.totalPoints:
        for (StatsData statsData in local.global.stats!) {
          mapList.add([statsData.userId, statsData.totalPoints]);
        }

        title = PStrings.totalPoints;
        break;

      case StatsType.usedCommands:
        for (StatsData statsData in local.global.stats!) {
          mapList.add([statsData.userId, statsData.usedCommands]);
        }

        title = PStrings.usedCommands;
        break;

      case StatsType.usedPoints:
        for (StatsData statsData in local.global.stats!) {
          mapList.add([statsData.userId, statsData.usedPoints]);
        }

        title = PStrings.pointsSpent;
        break;

      case StatsType.giftedMoney:
        for (StatsData statsData in local.global.stats!) {
          mapList.add([statsData.userId, statsData.giftedMoney]);
        }

        title = PStrings.moneySpent;
        break;

      case StatsType.transactions:
        for (StatsData statsData in local.global.stats!) {
          mapList.add([statsData.userId, statsData.transactions]);
        }

        title = PStrings.transactions;
        break;
    }

    return TitleWidget(text: title, child: StatsCard(mapList: mapList));
  }
}
