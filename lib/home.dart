import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab_5_2/graph.dart';
import 'package:lab_5_2/invitation.dart';
import 'package:lab_5_2/main.dart';
import 'package:lab_5_2/model/factory_model.dart';
import 'package:lab_5_2/model/minThreshold_model.dart';
import 'package:lab_5_2/services/api.dart';
import 'package:lab_5_2/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';
import 'package:lab_5_2/model/contact_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class firstPage extends StatefulWidget {
  const firstPage({super.key});

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  int currentIndex=1;
  int index=1;
  double total=0;
  double pressure=0;
  double flow=0;
  double water=0;
  double power=0;
  double minPressure=0;
  double minFlow=0;
  double minWater=0;
  double minPower=0;
  bool write=false;
  bool check = false;
  String id="66a5f5e1ad77c04a9856b9bb";
  String formattedDate = '';
  late Api api=Api();
  late Future<MinThreshold> futureMinThreshold=api.fetchMinThreshold(id);
  late Future<List<FactoryData>> futureFactory=api.fetchFactory(index);
  late Future<List<ContactData>> futureContact=api.fetchContact(index);
  late Future<List<ContactData>> futureOwner;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  late TextEditingController textEditingController4;
  WebSocketChannel? channel;
  StreamSubscription? _subscription;

  List<FactoryData>data=[];

  @override
  void initState() {
    super.initState();
    String number = (Provider.of<UserProvider>(context, listen: false).phoneNumber).substring(1);
    futureMinThreshold = api.fetchMinThreshold(id);
    futureOwner = api.fetchOwner(index, number);
    updateFactory(index, id);
  }

  void connectToWebSocket() {
    _subscription?.cancel();
    channel?.sink.close();

    channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080'));
    fetchData();
  }

  void fetchData() {
    channel?.sink.add(jsonEncode({'factory': index.toString()}));

    _subscription?.cancel();
    _subscription = channel!.stream.listen((message) {
      final data = jsonDecode(message);
      print('Received data: $data');
      if (data['error'] != null) {
        print('Error: ${data['error']}');
      } else {

          setState(() {
            total = double.tryParse(data['total'].toString()) ?? 0;
            pressure = double.tryParse(data['steamPressure'].toString()) ?? 0;
            flow = double.tryParse(data['steamFlow'].toString()) ?? 0;
            water = double.tryParse(data['waterLevel'].toString()) ?? 0;
            power = double.tryParse(data['powerFrequency'].toString()) ?? 0;
            formattedDate=data['date'];
          });

          if(pressure<=minPressure || flow<=minFlow || water<=minWater || power<=minPower){
            String message='Readings in factory $index fall outside the thresholds.';
            api.sendNotification((Provider.of<UserProvider>(context, listen: false).phoneNumber).substring(1), message);
          }
      }
    });
  }

  void updateFactory(int newIndex, String newId) {
    setState(() {
      index = newIndex;
      id = newId;
      futureFactory = api.fetchFactory(index);
      futureContact = api.fetchContact(index);
      futureMinThreshold = api.fetchMinThreshold(id);
      String number = (Provider.of<UserProvider>(context, listen: false).phoneNumber).substring(1);
      futureOwner = api.fetchOwner(index, number);
      _getMin();
      connectToWebSocket();
    });
    _fetchOwnerData();
  }

  Future<void> _fetchOwnerData() async {
    try {
      List<ContactData> data = await futureOwner;
      if(data.isEmpty){
        check=false;
      }
      if (data.isNotEmpty && data[0].role == 'owner' && data[0].factory == Provider.of<UserProvider>(context, listen: false).indexNum.toString()) {
        setState(() {
          check = true;
        });
      }
    } catch (e) {
      print('Error fetching owner data: $e');
    }
  }

  Future<void> _getMin() async{
    try{
      MinThreshold data = await futureMinThreshold;
      minPressure=double.parse(data.minSteamPressure);
      minFlow=double.parse(data.minSteamFlow);
      minWater=double.parse(data.minWaterLevel);
      minPower=double.parse(data.minPowerFrequency);
    }catch(e){
      print('Error fetching minThreshold');
    }
  }

  void stopWebSocket() {
    _subscription?.cancel();
    channel?.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    context.read<UserProvider>().change5(newDate: formattedDate);

            return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text('Factory ' + index.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
                  actions: [Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          setState(() {
                            currentIndex = 2;
                          });
                        },
                      ),
                      IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          icon: Icon(Icons.logout_rounded)
                      ),
                    ],
                  )
                  ]
              ),

              body: SingleChildScrollView(
                child: Container(
                  color: Color.fromRGBO(213, 205, 205, 1.0),
                  height: screenHeight * 1,
                  width: screenWidth * 1,
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(
                              screenWidth * 0.1, screenWidth * 0.1,
                              screenWidth * 0.1, screenWidth * 0.05),
                          height: screenHeight * 0.61,
                          width: screenWidth * 1,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(225, 222, 222, 1.0),
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: currentIndex == 1 ?
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0, screenWidth * 0.05, 0,
                                          screenWidth * 0.05),
                                      child:
                                      Text(
                                        total.toString() + 'kW',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ) ,
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              screenWidth * 0.01,
                                              screenWidth * 0.01,
                                              screenWidth * 0.05,
                                              screenWidth * 0.01),
                                          color: Color.fromRGBO(
                                              168, 166, 166, 1.0),
                                          height: screenHeight * 0.18,
                                          width: screenWidth * 0.3,
                                          alignment: Alignment.centerLeft,
                                          child:
                                          Column(
                                              children: <Widget>[
                                                Text('Steam Pressure',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: screenWidth * 0.034
                                                  ),),
                                                Expanded(
                                                  child:
                                                  GestureDetector(
                                                    onTap: (){
                                                      context.read<UserProvider>().change4(newState: 'Steam Pressure');
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder:(context)=>
                                                          const Graph(),
                                                        ),
                                                      );
                                                    },
                                                    child: SfRadialGauge(
                                                      enableLoadingAnimation: true,
                                                      axes: <RadialAxis>[
                                                        RadialAxis(
                                                          showLabels: false,
                                                          radiusFactor: 0.6,
                                                          ranges: [
                                                            GaugeRange(
                                                              startValue: 0,
                                                              endValue: 50,
                                                              sizeUnit: GaugeSizeUnit.factor,
                                                            ),
                                                            GaugeRange(
                                                              startValue: 50,
                                                              endValue: 100,
                                                              sizeUnit: GaugeSizeUnit
                                                                  .factor,
                                                            )
                                                          ],
                                                          pointers: [
                                                            RangePointer(
                                                              value: pressure,
                                                              color: Colors.green,
                                                            )
                                                          ],
                                                          annotations: [
                                                            GaugeAnnotation(
                                                              widget: Text(
                                                                pressure.toString() +
                                                                    ' bar',
                                                                style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.04
                                                                ),),
                                                              angle: 90,
                                                              positionFactor: 1.3,
                                                            )
                                                          ],
                                                        )
                                                      ],

                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),

                                        Container(
                                          color: Color.fromRGBO(
                                              168, 166, 166, 1.0),
                                          height: screenHeight * 0.18,
                                          width: screenWidth * 0.3,
                                          alignment: Alignment.centerRight,
                                          child:
                                          Column(
                                              children: <Widget>[
                                                Text('Steam Flow',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: screenWidth * 0.034
                                                  ),),
                                                Expanded(
                                                  child:
                                                  GestureDetector(
                                                    onTap: (){
                                                      context.read<UserProvider>().change4(newState: 'Steam Flow');
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder:(context)=>
                                                          const Graph(),
                                                        ),
                                                      );
                                                    },
                                                    child: SfRadialGauge(
                                                      enableLoadingAnimation: true,
                                                      axes: <RadialAxis>[
                                                        RadialAxis(
                                                          showLabels: false,
                                                          radiusFactor: 0.6,
                                                          ranges: [
                                                            GaugeRange(
                                                              startValue: 0,
                                                              endValue: 50,
                                                              sizeUnit: GaugeSizeUnit
                                                                  .factor,
                                                            ),
                                                            GaugeRange(
                                                              startValue: 50,
                                                              endValue: 100,
                                                              sizeUnit: GaugeSizeUnit
                                                                  .factor,
                                                            )
                                                          ],
                                                          pointers: [
                                                            RangePointer(
                                                              value: flow,
                                                              color: Colors.red,
                                                            )
                                                          ],
                                                          annotations: [
                                                            GaugeAnnotation(
                                                              widget: Text(
                                                                flow.toString() +
                                                                    ' T/H',
                                                                style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.04
                                                                ),),
                                                              angle: 90,
                                                              positionFactor: 1.3,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ]),

                                  Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              screenWidth * 0.08,
                                              screenWidth * 0.02,
                                              screenWidth * 0.05,
                                              screenWidth * 0.01),
                                          color: Color.fromRGBO(
                                              168, 166, 166, 1.0),
                                          height: screenHeight * 0.18,
                                          width: screenWidth * 0.3,
                                          alignment: Alignment.centerLeft,
                                          child:
                                          Column(
                                              children: <Widget>[
                                                Text('Water Level',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: screenWidth * 0.034
                                                  ),),
                                                Expanded(
                                                  child:
                                                  GestureDetector(
                                                    onTap: (){
                                                      context.read<UserProvider>().change4(newState: 'Water Level');
                                                      Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder:(context)=>
                                                        const Graph(),
                                                      ),
                                                    );},
                                                    child: SfRadialGauge(
                                                      enableLoadingAnimation: true,
                                                      axes: <RadialAxis>[
                                                        RadialAxis(
                                                          showLabels: false,
                                                          radiusFactor: 0.6,
                                                          ranges: [
                                                            GaugeRange(
                                                              startValue: 0,
                                                              endValue: 50,
                                                              sizeUnit: GaugeSizeUnit
                                                                  .factor,
                                                            ),
                                                            GaugeRange(
                                                              startValue: 50,
                                                              endValue: 100,
                                                              sizeUnit: GaugeSizeUnit
                                                                  .factor,
                                                            )
                                                          ],
                                                          pointers: [
                                                            RangePointer(
                                                              value: water,
                                                              color: Colors.green,
                                                            )
                                                          ],
                                                          annotations: [
                                                            GaugeAnnotation(
                                                              widget: Text(
                                                                water.toString() +
                                                                    ' %',
                                                                style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.04
                                                                ),),
                                                              angle: 90,
                                                              positionFactor: 1.3,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),

                                        Container(
                                          color: Color.fromRGBO(
                                              168, 166, 166, 1.0),
                                          height: screenHeight * 0.18,
                                          width: screenWidth * 0.3,
                                          alignment: Alignment.centerRight,
                                          child:
                                          Column(
                                              children: <Widget>[
                                                Text('Power Frequency',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: screenWidth * 0.034
                                                  ),),
                                                Expanded(
                                                  child:
                                                  GestureDetector(
                                                    onTap: (){
                                                      context.read<UserProvider>().change4(newState: 'Power Frequency');
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder:(context)=>
                                                          const Graph(),
                                                        ),
                                                      );
                                                    },
                                                    child: SfRadialGauge(
                                                      enableLoadingAnimation: true,
                                                      axes: <RadialAxis>[
                                                        RadialAxis(
                                                          showLabels: false,
                                                          radiusFactor: 0.6,
                                                          ranges: [
                                                            GaugeRange(
                                                              startValue: 0,
                                                              endValue: 50,
                                                              sizeUnit: GaugeSizeUnit
                                                                  .factor,
                                                            ),
                                                            GaugeRange(
                                                              startValue: 50,
                                                              endValue: 100,
                                                              sizeUnit: GaugeSizeUnit
                                                                  .factor,
                                                            )
                                                          ],
                                                          pointers: [
                                                            RangePointer(
                                                              value: power,
                                                              color: Colors.green,
                                                            )
                                                          ],
                                                          annotations: [
                                                            GaugeAnnotation(
                                                              widget: Text(
                                                                power.toString() +
                                                                    ' Hz',
                                                                style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.04
                                                                ),),
                                                              angle: 90,
                                                              positionFactor: 1.3,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ]),

                                  Container(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '$formattedDate',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.04
                                          ),
                                        ),
                                        SizedBox(
                                            width: screenWidth * 0.025
                                        ),
                                        Text(
                                          '$formattedTime',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          ) : currentIndex == 0 ?
                          FutureBuilder<List<ContactData>>(
                future: futureContact,
                  builder: (BuildContext context, AsyncSnapshot<List<ContactData>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      print('No data. Snapshot state: ${snapshot.connectionState}');
                      return Center(child: Text('No data available'));
                    } else {
                      print("Snapshot has data: ${snapshot.data}");
                      List<ContactData> pdata = snapshot.data!;

                      return Column(
                        key: Key('contact'),
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: pdata.length,
                              itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.all(screenWidth * 0.01),
                                margin: EdgeInsets.all(screenWidth * 0.05),
                                width: screenWidth * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '   ${pdata[index].name}',
                                      style: TextStyle(fontSize: screenWidth * 0.05),
                                    ),
                                    Text(
                                      '\u2022 ${pdata[index].phoneNumber}',
                                      style: TextStyle(fontSize: screenWidth * 0.05),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, screenWidth * 0.05, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: check,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const invitationPage(),
                                        ),
                                      );
                                    },
                                    iconSize: screenWidth * 0.1,
                                    padding: EdgeInsets.fromLTRB(0, 0, screenWidth * 0.01, screenWidth * 0.03),
                                    color: Colors.black,
                                    icon: Icon(Icons.add),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(17),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(245, 112, 245, 1.0),
                                      ),
                                      fixedSize: MaterialStateProperty.all<Size>(
                                        Size(screenWidth * 0.1, screenWidth * 0.1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                )
                              : FutureBuilder(
                              future: futureMinThreshold,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  print('Error: ${snapshot.error}');
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  print('No data. Snapshot state: ${snapshot
                                      .connectionState}');
                                  return Center(child: Text('No data available'));
                                } else {
                                  print("Snapshot has data: ${snapshot.data}");
                                  MinThreshold pdata = snapshot.data;
                                  textEditingController1 = TextEditingController(
                                      text: pdata.minSteamPressure.toString());
                                  textEditingController2 = TextEditingController(
                                      text: pdata.minSteamFlow.toString());
                                  textEditingController3 = TextEditingController(
                                      text: pdata.minWaterLevel.toString());
                                  textEditingController4 = TextEditingController(
                                      text: pdata.minPowerFrequency.toString());

                                  void updateMinThreshold() async {
                                    Map<String, dynamic> data = {
                                      'factory': Provider
                                          .of<UserProvider>(context, listen: false)
                                          .indexNum
                                          .toString(),
                                      'minSteamPressure': textEditingController1
                                          .text,
                                      'minSteamFlow': textEditingController2.text,
                                      'minWaterLevel': textEditingController3.text,
                                      'minPowerFrequency': textEditingController4
                                          .text,
                                    };

                                    try {
                                      MinThreshold updatedThreshold = await api
                                          .updateMinThreshold(id, data);
                                      setState(() {
                                        write = false;
                                        futureMinThreshold = Future.value(updatedThreshold);
                                      });
                                    } catch (e) {
                                      // Handle update error
                                      print('Update Error: $e');
                                    }
                                  }

                                  return Container(
                                    child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, screenWidth * 0.05, 0, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Text('Minimum Threshold',
                                                  style: TextStyle(
                                                      fontSize: screenWidth * 0.04,
                                                      fontWeight: FontWeight.bold
                                                  ),),
                                                SizedBox(
                                                    width: 10
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.info_outline_rounded,
                                                    size: screenWidth * 0.04,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      write = true;
                                                      stopWebSocket();
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.deepPurple,
                                                    size: screenWidth * 0.04,
                                                  ),
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                          RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(14),
                                                            side: BorderSide(
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                      ),
                                                      backgroundColor: MaterialStateProperty
                                                          .all<
                                                          Color>(
                                                        Colors.white,
                                                      ),
                                                      fixedSize: MaterialStateProperty
                                                          .all<Size>(
                                                          Size(screenWidth * 0.08,
                                                              screenWidth * 0.06)
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, screenWidth * 0.05, 0, 0),
                                                  alignment: Alignment.centerLeft,
                                                  child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),
                                                          child: Text(
                                                            'Steam Pressure',
                                                            style: TextStyle(
                                                                fontSize: screenWidth *
                                                                    0.03,
                                                                fontWeight: FontWeight
                                                                    .bold
                                                            ),),
                                                        ),
                                                        Container(
                                                          width: screenWidth * 0.3,
                                                          height: screenWidth * 0.2,
                                                          padding: EdgeInsets.all(
                                                              5),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),

                                                          child:
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextField(
                                                                  enabled: write,
                                                                  controller: textEditingController1,
                                                                  keyboardType: TextInputType
                                                                      .number,
                                                                  decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Colors
                                                                              .black,


                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10)
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.03,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                  ),
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                    width: screenWidth *
                                                                        0.01,
                                                                    height: screenHeight *
                                                                        0.06,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        border: Border
                                                                            .all(
                                                                            color: Colors
                                                                                .black
                                                                        )
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'bar',
                                                                        style: TextStyle(
                                                                            fontSize: screenWidth *
                                                                                0.04,
                                                                            fontWeight: FontWeight
                                                                                .bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]
                                                  )
                                              ),
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      screenWidth * 0.05,
                                                      screenWidth * 0.05,
                                                      screenWidth * 0.05, 0),
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),
                                                          child: Text('Steam Flow',
                                                            style: TextStyle(
                                                                fontSize: screenWidth *
                                                                    0.03,
                                                                fontWeight: FontWeight
                                                                    .bold
                                                            ),),
                                                        ),
                                                        Container(
                                                          width: screenWidth * 0.3,
                                                          height: screenWidth * 0.2,
                                                          padding: EdgeInsets.all(
                                                              5),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),

                                                          child:
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextField(
                                                                  keyboardType: TextInputType
                                                                      .number,
                                                                  controller: textEditingController2,
                                                                  enabled: write,
                                                                  decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10)
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.03,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                  ),
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                    width: screenWidth *
                                                                        0.04,
                                                                    height: screenHeight *
                                                                        0.06,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        border: Border
                                                                            .all(
                                                                            color: Colors
                                                                                .black
                                                                        )
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'T/H',
                                                                        style: TextStyle(
                                                                            fontSize: screenWidth *
                                                                                0.04,
                                                                            fontWeight: FontWeight
                                                                                .bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),
                                                          child: Text('Water Level',
                                                            style: TextStyle(
                                                                fontSize: screenWidth *
                                                                    0.03,
                                                                fontWeight: FontWeight
                                                                    .bold
                                                            ),),
                                                        ),
                                                        Container(
                                                          width: screenWidth * 0.3,
                                                          height: screenWidth * 0.2,
                                                          padding: EdgeInsets.all(
                                                              5),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),

                                                          child:
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextField(
                                                                  enabled: write,
                                                                  controller: textEditingController3,
                                                                  keyboardType: TextInputType
                                                                      .number,
                                                                  decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10)
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.03,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                  ),
                                                                  textAlign: TextAlign
                                                                      .center,

                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                    width: screenWidth *
                                                                        0.04,
                                                                    height: screenHeight *
                                                                        0.06,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        border: Border
                                                                            .all(
                                                                            color: Colors
                                                                                .black
                                                                        )
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        '%',
                                                                        style: TextStyle(
                                                                            fontSize: screenWidth *
                                                                                0.04,
                                                                            fontWeight: FontWeight
                                                                                .bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]
                                                  )
                                              ),
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      screenWidth * 0.05, 0,
                                                      screenWidth * 0.01, 0),
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),
                                                          child: Text(
                                                            'Power Frequency',
                                                            style: TextStyle(
                                                                fontSize: screenWidth *
                                                                    0.03,
                                                                fontWeight: FontWeight
                                                                    .bold
                                                            ),),
                                                        ),
                                                        Container(
                                                          width: screenWidth * 0.3,
                                                          height: screenWidth * 0.2,
                                                          padding: EdgeInsets.all(
                                                              5),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 10),

                                                          child:
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextField(
                                                                  controller: textEditingController4,
                                                                  enabled: write,
                                                                  keyboardType: TextInputType
                                                                      .number,
                                                                  decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10)
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize: screenWidth *
                                                                        0.03,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                  ),
                                                                  textAlign: TextAlign
                                                                      .center,

                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                    width: screenWidth *
                                                                        0.04,
                                                                    height: screenHeight *
                                                                        0.06,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        border: Border
                                                                            .all(
                                                                            color: Colors
                                                                                .black
                                                                        )
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Hz',
                                                                        style: TextStyle(
                                                                            fontSize: screenWidth *
                                                                                0.04,
                                                                            fontWeight: FontWeight
                                                                                .bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            write == true ?
                                                            ElevatedButton(
                                                                key: Key('save'),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    write = false;
                                                                    connectToWebSocket();
                                                                  });

                                                                  updateMinThreshold();
                                                                },
                                                                child: Text('Save',
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth *
                                                                          0.04
                                                                  ),)) : Container()
                                                          ],
                                                        )
                                                      ]
                                                  )
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),
                                  );
                                }
                              }))
                      ,

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(
                                45, 0, 75, screenWidth * 0.04),
                            child:
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      updateFactory(1, "66a5f5e1ad77c04a9856b9bb");
                                      index = 1;
                                      formattedTime =
                                          DateFormat('HH:mm:ss').format(now);
                                      context.read<UserProvider>().change2(
                                          newIndex: index);
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      id = "66a5f5e1ad77c04a9856b9bb";
                                      futureMinThreshold =
                                          api.fetchMinThreshold(id);
                                    });
                                  },

                                  padding: EdgeInsets.all(15),
                                  iconSize: screenWidth * 0.1,
                                  color: Colors.black,
                                  icon: Column(
                                    children: [
                                      Icon(
                                          Icons.factory
                                      ),
                                      Text('Factory 1',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04
                                        ),)
                                    ],
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            side: BorderSide(
                                              color: index == 1
                                                  ? Colors.blue
                                                  : Colors.white,
                                            ),
                                          )),
                                      backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                        Color.fromRGBO(232, 228, 228, 1.0),
                                      ),
                                      fixedSize: MaterialStateProperty.all<Size>(
                                        Size(
                                            screenWidth * 0.25, screenWidth * 0.25),
                                      )
                                  ),
                                ),

                                SizedBox(
                                  width: 40,
                                ),

                                IconButton(
                                  onPressed: () {
                                    updateFactory(2, "66a5f779f0a750364c556b75");
                                    setState(() {
                                      index = 2;
                                      formattedTime =
                                          DateFormat('HH:mm:ss').format(now);
                                      context.read<UserProvider>().change2(
                                          newIndex: index);
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      id = "66a5f779f0a750364c556b75";
                                      futureMinThreshold = api.fetchMinThreshold(id);
                                      futureFactory=api.fetchFactory(index);
                                    });
                                  },
                                  padding: EdgeInsets.all(15),
                                  iconSize: screenWidth * 0.1,
                                  color: Colors.black,
                                  icon: Column(
                                    children: [
                                      Icon(
                                          Icons.factory
                                      ),
                                      Text('Factory 2',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04
                                        ),)
                                    ],
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            side: BorderSide(
                                              color: index == 2
                                                  ? Colors.blue
                                                  : Colors.white,
                                            ),
                                          )),
                                      backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                        Color.fromRGBO(232, 228, 228, 1.0),
                                      ),
                                      fixedSize: MaterialStateProperty.all<Size>(
                                        Size(
                                            screenWidth * 0.25, screenWidth * 0.25),
                                      )
                                  ),
                                ),

                                SizedBox(
                                  width: 40,
                                ),

                                IconButton(
                                  onPressed: () {
                                    updateFactory(3, "66a5f795f0a750364c556b77");
                                    setState(() {
                                      index = 3;
                                      formattedTime =
                                          DateFormat('HH:mm:ss').format(now);
                                      context.read<UserProvider>().change2(
                                          newIndex: index);
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      id = "66a5f795f0a750364c556b77";
                                      futureMinThreshold =
                                          api.fetchMinThreshold(id);
                                    });
                                  },
                                  padding: EdgeInsets.all(15),
                                  iconSize: screenWidth * 0.1,
                                  color: Colors.black,
                                  icon: Column(
                                    children: [
                                      Icon(
                                          Icons.factory
                                      ),
                                      Text('Factory 3',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04
                                        ),)
                                    ],
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            side: BorderSide(
                                              color: index == 3
                                                  ? Colors.blue
                                                  : Colors.white,
                                            ),
                                          )),
                                      backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                        Color.fromRGBO(232, 228, 228, 1.0),
                                      ),
                                      fixedSize: MaterialStateProperty.all<Size>(
                                        Size(
                                            screenWidth * 0.25, screenWidth * 0.25),
                                      )
                                  ),
                                ),
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),

              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person,),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings,
                        key: Key('button settings')),
                    label: '',
                  )
                ],
                currentIndex: currentIndex,
                onTap: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                selectedItemColor: Colors.blue,
              ),
            );
          }

}
