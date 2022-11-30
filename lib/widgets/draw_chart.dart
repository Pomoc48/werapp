import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:wera_f2/settings.dart';

class DrawChart extends StatelessWidget {
  const DrawChart({Key? key, required this.chartData}) : super(key: key);

  final List<double> chartData;

  @override
  Widget build(BuildContext context) {
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
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primary,
            ],
          ),
          enableGridLines: true,
          gridLineColor: PColors().surfaceVar(context),
          data: chartData,
          lineColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
