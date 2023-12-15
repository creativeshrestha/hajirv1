import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LineChart({Key? key}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<ChartData> data = [
    ChartData('Jan', 35.53),
    ChartData('Feb', 46.06),
    ChartData('Mar', 46.06),
    ChartData('Apr', 50.86),
    ChartData('May', 60.89),
    ChartData('Jun', 70.27),
    ChartData('Jul', 75.65),
    ChartData('Aug', 74.70),
    ChartData('Sep', 65.91),
    ChartData('Oct', 54.28),
    ChartData('Nov', 46.33),
    ChartData('Dec', 35.71),
    // ChartData('Jan', 35),
    // ChartData('Feb', 28),
    // ChartData('Mar', 34),
    // ChartData('Apr', 32),
    // ChartData('May', 40),
    // ChartData('Jun', 40),
    // ChartData('Jul', 40)
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Column(children: [
        //Initialize the chart widget
        Expanded(
          flex: 3,
          child: SfCartesianChart(
            borderWidth: 0,
            borderColor: Colors.white,

            plotAreaBorderWidth: 0,
            plotAreaBackgroundColor: Colors.white,

            plotAreaBorderColor: Colors.white,
            primaryXAxis: CategoryAxis(
              axisBorderType: AxisBorderType.withoutTopAndBottom,
              isVisible: true,
              axisLine: const AxisLine(width: 0, color: Colors.red),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
              borderWidth: 0,
            ),
            primaryYAxis: NumericAxis(
                interval: 20,
                axisLine: const AxisLine(width: 0, color: Colors.red),
                // majorGridLines: MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(width: 0)),

            // Chart title
            // title: ChartTitle(text: 'Half yearly sales analysis'),
            // Enable legend
            legend: Legend(isVisible: false),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<ChartData, String>>[
              AreaSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData sales, _) => sales.year,
                  yValueMapper: (
                    ChartData sales,
                    _,
                  ) =>
                      sales.sales,
                  borderWidth: 2,
                  borderGradient: const LinearGradient(colors: <Color>[
                    Color.fromRGBO(230, 0, 180, 1),
                    Color.fromRGBO(255, 200, 0, 1)
                  ], stops: <double>[
                    0.2,
                    0.9
                  ]),
                  name: 'Attendance',
                  color: Colors.grey.shade200,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.grey.shade400,
                      Colors.grey.shade300,
                      Colors.grey.shade200,
                      Colors.white,
                      Colors.white
                    ],
                  ),
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true)),
            ],
          ),
        ),
        // Expanded(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     //Initialize the spark charts widget
        //     child: SfSparkLineChart.custom(
        //       //Enable the trackball
        //       trackball: SparkChartTrackball(
        //           activationMode: SparkChartActivationMode.tap),
        //       //Enable marker
        //       marker: SparkChartMarker(
        //           displayMode: SparkChartMarkerDisplayMode.all),
        //       //Enable data label
        //       labelDisplayMode: SparkChartLabelDisplayMode.all,
        //       xValueMapper: (int index) => data[index].year,
        //       yValueMapper: (int index) => data[index].sales,
        //       dataCount: 3,
        //     ),
        //   ),
        // )
      ]),
    );
  }
}

class ChartData {
  ChartData(this.year, this.sales);

  final String year;
  final double sales;
}
