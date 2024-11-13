import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(const SynchronizedCrosshair());

class SynchronizedCrosshair extends StatelessWidget {
  const SynchronizedCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synchronized Crosshair',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CrosshairSynchronization(),
    );
  }
}

class CrosshairSynchronization extends StatefulWidget {
  const CrosshairSynchronization({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CrosshairSynchronizationState createState() =>
      _CrosshairSynchronizationState();
}

class _CrosshairSynchronizationState extends State<CrosshairSynchronization> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(child: FirstChart()),
            Expanded(child: SecondChart()),
          ],
        ),
      ),
    );
  }
}

CrosshairBehavior _crosshair1 = CrosshairBehavior(
  enable: true,
  activationMode: ActivationMode.singleTap,
);
CrosshairBehavior _crosshair2 = CrosshairBehavior(
  enable: true,
  activationMode: ActivationMode.singleTap,
);

ChartSeriesController? _secondChartController;
ChartSeriesController? _firstChartController;

Offset? _firstPosition;
Offset? _secondPosition;

List<ChartData> _getChartData() {
  return <ChartData>[
    ChartData(1, 15),
    ChartData(2, 25),
    ChartData(3, 35),
    ChartData(4, 20),
    ChartData(5, 40),
    ChartData(6, 30),
    ChartData(7, 45),
    ChartData(8, 25),
    ChartData(9, 50),
    ChartData(10, 30),
  ];
}

class FirstChart extends StatefulWidget {
  const FirstChart({super.key});

  @override
  State<StatefulWidget> createState() {
    return FirstChartState();
  }
}

class FirstChartState extends State<FirstChart> {
  List<ChartData>? _chartData;

  bool _isInteractive = false;

  @override
  void initState() {
    super.initState();
    _chartData = _getChartData();
  }

  void show(Offset position) {
    final CartesianChartPoint chartPoint =
        _secondChartController!.pixelToPoint(position);
    _secondPosition = _secondChartController!.pointToPixel(chartPoint);
    _crosshair2.show(_secondPosition!.dx, _secondPosition!.dy, 'pixel');
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = true;
        show(tapArgs.position);
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = false;
        _crosshair2.hide();
      },
      onChartTouchInteractionMove: (ChartTouchInteractionArgs tapArgs) {
        if (_isInteractive) {
          show(tapArgs.position);
        }
      },
      crosshairBehavior: _crosshair1,
      title: const ChartTitle(text: 'Chart 1'),
      backgroundColor: Colors.white,
      plotAreaBorderWidth: 0,
      series: <CartesianSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataSource: _chartData,
          xValueMapper: (ChartData data, int index) => data.x,
          yValueMapper: (ChartData data, int index) => data.y,
          onRendererCreated: (ChartSeriesController controller) {
            _firstChartController = controller;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chartData!.clear();
    _firstChartController = null;
    super.dispose();
  }
}

class SecondChart extends StatefulWidget {
  const SecondChart({super.key});

  @override
  State<StatefulWidget> createState() {
    return SecondChartState();
  }
}

class SecondChartState extends State<SecondChart> {
  List<ChartData>? _chartData;

  bool _isInteractive = false;

  @override
  void initState() {
    super.initState();
    _chartData = _getChartData();
  }

  void show(Offset position) {
    final CartesianChartPoint chartPoint =
        _firstChartController!.pixelToPoint(position);
    _firstPosition = _firstChartController!.pointToPixel(chartPoint);
    _crosshair1.show(_firstPosition!.dx, _firstPosition!.dy, 'pixel');
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = true;
        show(tapArgs.position);
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = false;
        _crosshair1.hide();
      },
      onChartTouchInteractionMove: (tapArgs) {
        if (_isInteractive) {
          show(tapArgs.position);
        }
      },
      backgroundColor: Colors.white,
      title: const ChartTitle(text: 'Chart 2'),
      crosshairBehavior: _crosshair2,
      series: <CartesianSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataSource: _chartData,
          xValueMapper: (ChartData data, int index) => data.x,
          yValueMapper: (ChartData data, int index) => data.y,
          onRendererCreated: (ChartSeriesController controller) {
            _secondChartController = controller;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chartData!.clear();
    _secondChartController = null;
    super.dispose();
  }
}

class ChartData {
  ChartData(this.x, this.y);
  double? x;
  num? y;
}
