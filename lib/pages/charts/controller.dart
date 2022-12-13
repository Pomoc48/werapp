import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:wera_f2/models/chart_data.dart';
import 'package:wera_f2/get_controller.dart';

class ChartController extends GetxController{
  bool _initial = true;
  int chartDays = 30;

  final FadeInController controller = FadeInController();
  final GlobalController global = Get.find();

  bool mathDates(DateTime d1, DateTime d2) {
    if (d1.day != d2.day) return false;
    if (d1.month != d2.month) return false;
    if (d1.year != d2.year) return false;
    return true;
  }

  List<double> fixChartHoles(List<double> chartData) {
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

  List<double> convertData(List<ChartDataElement>? chartDataElemens) {
    List<double> chartDataList = [];

    if (chartDataElemens == null) return [0.0];

    for (int a = 0; a < chartDays; a++) {
      DateTime now = DateTime.now().subtract(Duration(days: a));
      bool match = false;

      for (ChartDataElement element in chartDataElemens) {
        if (mathDates(element.date, now)) {
          chartDataList.add(element.value.toDouble());
          match = true;
        }
      }

      if (!match) chartDataList.add(0.0);
    }

    return fixChartHoles(chartDataList);
  }

  void getCharts() async {
    controller.fadeOut();
    global.updateCharts();
    controller.fadeIn();
  }

  pageSetup() {
    if (_initial) {
      getCharts();
      _initial = false;
    }
  }
}
