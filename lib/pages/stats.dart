import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/stats_data.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/cards/stats.dart';
import 'package:wera_f2/widgets/drawer.dart';
import 'package:wera_f2/widgets/title_widget.dart';

void main() => runApp(StatsPage());

enum StatsType {
  totalPoints,
  usedCommands,
  usedPoints,
  giftedMoney,
  transactions,
}

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

class StatsPage extends StatelessWidget {
  StatsPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => _getStats());

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        return WillPopScope(
          onWillPop: () async => await logoutConfirm(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text(PStrings.stats),
              automaticallyImplyLeading: isMobile(c),
            ),
            drawer: drawDrawer(c, const PDrawer()),
            body: RefreshIndicator(
              onRefresh: () async => _getStats(),
              child: FadeIn(
                controller: local.controller,
                child: Obx(() => _main(c, global.stats)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _main(BoxConstraints constraints, List<StatsData>? data) {
    if (data == null) return const SizedBox();

    List<Widget> stats = [];
    for (var value in StatsType.values) {
      stats.add(_statType(value));
    }

    return getLayout(
      constraints: constraints,
      drawer: !isMobile(constraints),
      children: stats,
    );
  }

  Widget _statType(StatsType type) {
    List<List> mapList = [];
    String title;

    switch (type) {
      case StatsType.totalPoints:
        for (StatsData statsData in global.stats!) {
          mapList.add([statsData.userId, statsData.totalPoints]);
        }

        title = PStrings.totalPoints;
        break;

      case StatsType.usedCommands:
        for (StatsData statsData in global.stats!) {
          mapList.add([statsData.userId, statsData.usedCommands]);
        }

        title = PStrings.usedCommands;
        break;

      case StatsType.usedPoints:
        for (StatsData statsData in global.stats!) {
          mapList.add([statsData.userId, statsData.usedPoints]);
        }

        title = PStrings.pointsSpent;
        break;

      case StatsType.giftedMoney:
        for (StatsData statsData in global.stats!) {
          mapList.add([statsData.userId, statsData.giftedMoney]);
        }

        title = PStrings.moneySpent;
        break;

      case StatsType.transactions:
        for (StatsData statsData in global.stats!) {
          mapList.add([statsData.userId, statsData.transactions]);
        }

        title = PStrings.transactions;
        break;
    }

    return TitleWidget(text: title, child: StatsCard(mapList: mapList));
  }

  Future<void> _getStats() async {
    local.controller.fadeOut();
    Map map = await query(link: "stats", type: RequestType.get);

    if (map["success"]) {
      global.updateStats(statsDataListFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.controller.fadeIn();
  }
}
