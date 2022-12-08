import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/classes/chart_data.dart';
import 'package:wera_f2/classes/user.dart';
import 'package:wera_f2/functions.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/layouts/layout.dart';
import 'package:wera_f2/server_query.dart';
import 'package:wera_f2/strings.dart';
import 'package:wera_f2/widgets/draw_chart.dart';
import 'package:wera_f2/widgets/title_widget.dart';
import 'package:wera_f2/widgets/widget_from_list.dart';

void main() => runApp(ChartsPage());

class LocalController extends GetxController{
  bool _initial = true;
  int chartDays = 30;

  final FadeInController controller = FadeInController();

  runOnce(Function() fun) {
    if (_initial) {
      fun();
      _initial = false;
    }
  }
}

class ChartsPage extends StatelessWidget {
  ChartsPage({super.key});

  final GlobalController global = Get.find();
  final LocalController local = LocalController();

  @override
  Widget build(BuildContext context) {
    local.runOnce(() => _getCharts(context));

    return PLayout(
      title: PStrings.charts,
      drawer: true,
      logoutConfirm: true,
      onRefresh: () async => _getCharts(context),
      scrollable: true,
      child: Obx(() => WidgetFromList(
        contextWidth: context.width,
        children: _main(global.charts),
      )),
    );
  }

  List<Widget> _main(List<ChartData>? data) {
    if (data == null) return [];

    List<Widget> widgets = [];

    for (int i = 0; i < data.length; i++) {
      User user = findUser(
        id: data[i].userId,
        userList: global.homeData!.users,
      );

      widgets.add(_containerItem(
        "${user.name} - ${PStrings.currentPoints}",
        DrawChart(chartData: _convertData(data[i].points)),
      ));

      widgets.add(_containerItem(
        "${user.name} - ${PStrings.totalPoints}",
        DrawChart(chartData: _convertData(data[i].totalPoints)),
      ));
    }

    return widgets;
  }

  List<double> _fixChartHoles(List<double> chartData) {
    chartData = List<double>.from(chartData.reversed);

    double? findStart;
    for (int a = 0; a < chartData.length; a++) {
      if (chartData[a] != 0.0) {
        findStart = chartData[a];
        break;
      }
    }

    findStart ??= 0.0;

    double? last;
    for (int b = 0; b < chartData.length; b++) {
      if (chartData[b] == 0.0) {
        if (last is! double) {
          chartData[b] = findStart;
        } else {
          chartData[b] = last;
        }
      } else {
        last = chartData[b];
      }
    }

    return chartData;
  }

  bool _mathDates(DateTime d1, DateTime d2) {
    if (d1.day != d2.day) return false;
    if (d1.month != d2.month) return false;
    if (d1.year != d2.year) return false;
    return true;
  }

  TitleWidget _containerItem(String title, Widget widget) {
    return TitleWidget(text: title, child: widget);
  }

  Future<void> _getCharts(BuildContext context) async {
    local.controller.fadeOut();
    Map map = await query(link: "chart", type: RequestType.get);

    if (map["success"]) {
      global.updateCharts(chartDataFromList(map["data"]));
    } else {
      snackBar(Get.context!, map["message"]);
    }

    local.controller.fadeIn();
  }

  List<double> _convertData(List<ChartDataElement>? chartDataElemens) {
    List<double> chartDataList = [];

    if (chartDataElemens == null) return [0.0];

    for (int a = 0; a < local.chartDays; a++) {
      DateTime now = DateTime.now().subtract(Duration(days: a));
      bool match = false;

      for (ChartDataElement element in chartDataElemens) {
        if (_mathDates(element.date, now)) {
          chartDataList.add(element.value.toDouble());
          match = true;
        }
      }

      if (!match) chartDataList.add(0.0);
    }

    return _fixChartHoles(chartDataList);
  }
}
