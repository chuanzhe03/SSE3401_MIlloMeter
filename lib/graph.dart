import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_5_2/model/averageThreshold_model.dart';
import 'package:lab_5_2/model/maxThreshold_model.dart';
import 'package:lab_5_2/model/minThreshold_model.dart';
import 'package:lab_5_2/services/api.dart';
import 'package:lab_5_2/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'model/factory_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  late Api api = Api();
  late Future<List<MinThreshold>> futureMinThreshold;
  late Future<List<MaxThreshold>> futureMaxThreshold;
  late Future<List<AverageThreshold>> futureAverageThreshold;
  late Future<List<FactoryData>> futureFactory;
  List<FactoryData> factory = [];
  int index = 0;
  double min = 0;
  double max = 0;
  double average = 0;
  String state = '';
  String date = '';
  int? year = 0;
  int ? month = 0;
  int ? day = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData(){
    index = Provider.of<UserProvider>(context, listen: false).indexNum;
    state = Provider.of<UserProvider>(context, listen: false).state;
    date = Provider.of<UserProvider>(context, listen: false).date;
    year = int.parse(date.substring(0, 4));
    month = int.parse(date.substring(5, 7));
    day = int.parse(date.substring(8, 10));
    futureMinThreshold = api.getMinThreshold(index);
    futureMaxThreshold = api.fetchMaxThreshold(index);
    futureAverageThreshold = api.fetchAverageThreshold(index);
    futureFactory = api.getFactory(index, date);
  }

  Future<void> _getMin() async {
    try {
      List<MinThreshold> data = await futureMinThreshold;
      if (state == 'Steam Pressure') {
        min = double.parse(data[0].minSteamPressure);
      }
      if (state == 'Steam Flow') {
        min = double.parse(data[0].minSteamFlow);
      }
      if (state == 'Water Level') {
        min = double.parse(data[0].minWaterLevel);
      }
      if (state == 'Power Frequency') {
        min = double.parse(data[0].minPowerFrequency);
      }
    } catch (e) {
      print('Error fetching minThreshold: $e');
    }
  }

  Future<void> _getMax() async {
    try {
      List<MaxThreshold> data = await futureMaxThreshold;
      if (state == 'Steam Pressure') {
        max = double.parse(data[0].maxSteamPressure);
      }
      if (state == 'Steam Flow') {
        max = double.parse(data[0].maxSteamFlow);
      }
      if (state == 'Water Level') {
        max = double.parse(data[0].maxWaterLevel);
      }
      if (state == 'Power Frequency') {
        max = double.parse(data[0].maxPowerFrequency);
      }
    } catch (e) {
      print('Error fetching maxThreshold: $e');
    }
  }

  Future<void> _getAverage() async {
    try {
      List<AverageThreshold> data = await futureAverageThreshold;
      if (state == 'Steam Pressure') {
        average = double.parse(data[0].averageSteamPressure);
      }
      if (state == 'Steam Flow') {
        average = double.parse(data[0].averageSteamFlow);
      }
      if (state == 'Water Level') {
        average = double.parse(data[0].averageWaterLevel);
      }
      if (state == 'Power Frequency') {
        average = double.parse(data[0].averagePowerFrequency);
      }
    } catch (e) {
      print('Error fetching averageThreshold: $e');
    }
  }

  Future<void> _getFactory() async {
    try {
      factory = await futureFactory;
    } catch (e) {
      print('Error fetching factory data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          'millopi0001-' + context.watch<UserProvider>().state,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenHeight * 0.02,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([
          _getMin(),
          _getMax(),
          _getAverage(),
          _getFactory(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<ChartData> chartData1 = [];
            for (int i = 0; i < factory.length; i++) {
              int hour = int.parse(factory[i].time.substring(0, 2));
              int minute = int.parse(factory[i].time.substring(3, 5));
              chartData1.add(ChartData(DateTime(year!, month!, day!, hour, minute), min));
            }

            final List<ChartData> chartData2 = [];
            for (int i = 0; i < factory.length; i++) {
              int hour = int.parse(factory[i].time.substring(0, 2));
              int minute = int.parse(factory[i].time.substring(3, 5));
              chartData2.add(ChartData(DateTime(year!, month!, day!, hour, minute), max));
            }

            final List<ChartData> chartData3 = [];
            for (int i = 0; i < factory.length; i++) {
              int hour = int.parse(factory[i].time.substring(0, 2));
              int minute = int.parse(factory[i].time.substring(3, 5));
              chartData3.add(ChartData(DateTime(year!, month!, day!, hour, minute), average));
            }

            final List<ChartData> chartData4 = [];
            for (int i = 0; i < factory.length; i++) {
              int hour = int.parse(factory[i].time.substring(0, 2));
              int minute = int.parse(factory[i].time.substring(3, 5));
              double data = 0;
              if (state == 'Steam Pressure') {
                data = double.parse(factory[i].steamPressure);
              }
              if (state == 'Steam Flow') {
                data = double.parse(factory[i].steamFlow);
              }
              if (state == 'Water Level') {
                data = double.parse(factory[i].waterLevel);
              }
              if (state == 'Power Frequency') {
                data = double.parse(factory[i].powerFrequency);
              }
              chartData4.add(ChartData(DateTime(year!, month!, day!, hour, minute), data));
            }

            final List<List<ChartData>> chartData = [
              chartData1,
              chartData2,
              chartData3,
              chartData4
            ];

            return Column(
              children: [
                Center(
                  child: Text(
                    context.watch<UserProvider>().date,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.02,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                    enableMouseWheelZooming: true,
                    enablePinching: true,
                  ),
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('HH:mm'),
                  ),
                  series: <CartesianSeries>[
                    AreaSeries<ChartData, DateTime>(
                      dataSource: chartData.elementAt(1),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.blue,
                    ),
                    LineSeries<ChartData, DateTime>(
                      dataSource: chartData.elementAt(2),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.amber,
                      width: 2.5,
                    ),
                    AreaSeries<ChartData, DateTime>(
                      dataSource: chartData.elementAt(0),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.blue[200],
                    ),
                    LineSeries<ChartData, DateTime>(
                      dataSource: chartData.elementAt(3),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.red,
                      dashArray: <double>[5, 5],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  height: screenWidth*0.08,
                  margin: EdgeInsets.all(screenWidth*0.03),
                  padding: EdgeInsets.all(screenWidth*0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        )
                      ]),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                        size: 15,
                      ),
                      Text('  Max'),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.circle,
                        color: Colors.amber,
                        size: 15,
                      ),
                      Text('  Average'),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.circle,
                        color: Colors.blue[200],
                        size: 15,
                      ),
                      Text('  Minimum'),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 15,
                      ),
                      Text('  Threshold'),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(screenWidth*0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.range,
                    showActionButtons: true,
                    onSubmit: (value) {
                        PickerDateRange? range = value as PickerDateRange?;
                        DateTime? startDate = range?.startDate;
                        DateTime? endDate = range?.endDate ;
                        setState(() {
                            Provider.of<UserProvider>(context, listen: false)
                              .change5(newDate:
                            '${startDate?.year}-${startDate?.month.toString()
                              .padLeft(2, '0')}-${startDate?.day.toString()
                              .padLeft(2, '0')}');
                            year = startDate?.year;
                            month = startDate?.month;
                            day = startDate?.day;
                            _initializeData();
                            _getMin();
                            _getMax();
                            _getAverage();
                           _getFactory();
                        }
                        );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
