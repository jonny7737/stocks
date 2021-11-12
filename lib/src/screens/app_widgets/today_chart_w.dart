import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/backfill_complete.dart';
import 'package:stocks/src/controllers/current_position.dart';
import 'package:stocks/src/controllers/max_value.dart';
import 'package:stocks/src/models/todays_chart_viewmodel.dart';
import 'package:stocks/src/models/todays_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class TodayChartWidget extends StatelessWidget {
  TodayChartWidget({Key? key}) : super(key: key);

  final _trackballBehavior = TrackballBehavior(
    enable: true,
    shouldAlwaysShow: true,
    activationMode: ActivationMode.singleTap,
    lineDashArray: const [5, 5],
    lineWidth: 1,
    hideDelay: 4000,
    markerSettings: const TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible, width: 6, height: 6),
    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
  );

  final _vm = TodaysChartViewModel();

  @override
  Widget build(BuildContext context) {
    context.watch<BackfillCompleteController>();
    context.watch<CurrentPositionController>();
    return SfTheme(
      data: SfThemeData(
          chartThemeData: SfChartThemeData(legendTextColor: Colors.black),
          brightness: Brightness.dark),
      child: SfCartesianChart(
        trackballBehavior: _trackballBehavior,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        primaryXAxis: DateTimeAxis(
          isVisible: false,
          plotOffset: 5,
          minimum: _vm.xMin,
        ),

        //  Add right hand y-axis so that the chart can be clicked on the
        //  last data point.  Also, the chart looks better with axes at both
        //  ends.
        axes: [
          NumericAxis(
            name: 'y2',
            opposedPosition: true,
            interval: 2,
            minorTicksPerInterval: 1,
            minimum: _vm.minY,
            maximum: _vm.maxY,
          )
        ],
        primaryYAxis: NumericAxis(
          name: 'y1',
          // plotOffset: 0,
          interval: 2,
          minorTicksPerInterval: 1,
          minimum: _vm.minY,
          maximum: _vm.maxY,
          plotBands: <PlotBand>[
            PlotBand(
                start: _vm.lastClose,
                end: _vm.lastClose,
                borderWidth: 1,
                dashArray: const <double>[5, 8]),
          ],
        ),
        series: <ChartSeries<TodaysData, DateTime>>[
          //  Primary dataset.
          LineSeries<TodaysData, DateTime>(
            name: 'Gain/Loss',
            dataSource: _vm.td,
            xValueMapper: (TodaysData _td, dt) =>
                _td.gainLoss == -double.infinity ? null : _td.tick,
            yValueMapper: (TodaysData _td, dt) =>
                _td.gainLoss == -double.infinity ? null : _td.gainLoss,

            //  Activate the right hand y-axis
            yAxisName: 'y2',
            // dataLabelSettings: const DataLabelSettings(
            //   borderWidth: 1,
            //   margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            //   // offset: useProvider(dataLabelOffsetProvider).state,
            //   isVisible: true,
            //   // showZeroValue: false,
            //   // connectorLineSettings:
            //   //     ConnectorLineSettings(width: 10, color: Colors.black),
            // ),
            dataLabelMapper: (TodaysData data, int i) {
              if (data.gainLoss >= context.watch<MaxValueController>().maxValue) {
                // print(
                //     '[TodaysChart] ${data.gainLoss} : ${context.read(maxValueProvider).state}');
                _vm.setDLO(i);
                return data.gainLoss.toStringAsFixed(2);
              }
              return null;
            },
          ),
        ],
        onTrackballPositionChanging: (args) {
          // print('[TCW] ${args.chartPointInfo.chartDataPoint?.currentPoint}');
          args.chartPointInfo.header = args.chartPointInfo.chartDataPoint!.x.toString();
          bool gain = args.chartPointInfo.chartDataPoint!.y > 0;
          String value = args.chartPointInfo.chartDataPoint!.y.abs().toStringAsFixed(2);
          if (gain) {
            args.chartPointInfo.label = '\$$value';
          } else {
            args.chartPointInfo.label = '(\$$value)';
          }
        },
      ),
    );
  }
}
