import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/chart_data.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/pages/charts/controller.dart';
import 'package:wera_f2/settings.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/title_widget.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

class ChartsPage extends StatelessWidget {
  ChartsPage({super.key});

  final ChartController local = ChartController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => local.getCharts());

    return PLayout(
      title: PStrings.charts,
      drawer: true,
      logoutConfirm: true,
      onRefresh: () async => local.getCharts(),
      scrollable: true,
      fadeController: local.controller,
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(local.global.charts),
      )),
    );
  }

  List<Widget> _main(List<ChartData>? data) {
    if (data == null) return [];

    List<Widget> widgets = [];

    for (int i = 0; i < data.length; i++) {
      User user = findUser(
        id: data[i].userId,
        userList: local.global.homeData!.users,
      );

      widgets.add(_containerItem(
        "${user.name} - ${PStrings.currentPoints}",
        _drawChart(local.convertData(data[i].points)),
      ));

      widgets.add(_containerItem(
        "${user.name} - ${PStrings.totalPoints}",
        _drawChart(local.convertData(data[i].totalPoints)),
      ));
    }

    return widgets;
  }

  TitleWidget _containerItem(String title, Widget widget) {
    return TitleWidget(text: title, child: widget);
  }

  Widget _drawChart(List<double> chartData) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 0, 16),
        child: Sparkline(
          lineWidth: 2,
          lineGradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Theme.of(Get.context!).colorScheme.primaryContainer,
              Theme.of(Get.context!).colorScheme.primary,
            ],
          ),
          enableGridLines: true,
          gridLineColor: PColors().surfaceVar(Get.context!),
          data: chartData,
          lineColor: Theme.of(Get.context!).colorScheme.primary,
        ),
      ),
    );
  }
}
