import 'package:flutter/material.dart';
import 'package:lab_5_2/main.dart';
import 'package:lab_5_2/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';
import 'invitation.dart';

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
  String formattedDate = '--';
  String formattedTime = '--';
  bool write=false;
  TextEditingController textEditingController1=TextEditingController(text: '0');
  TextEditingController textEditingController2=TextEditingController(text: '0');
  TextEditingController textEditingController3=TextEditingController(text: '0');
  TextEditingController textEditingController4=TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Factory '+index.toString(),
            style:TextStyle(fontWeight: FontWeight.bold,),
          ),
          actions: [IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              setState(() {
                currentIndex=2;
              });
            },
          )
          ]
      ),

      body: SingleChildScrollView(
        child: Container(
          color:Color.fromRGBO(213, 205, 205, 1.0),
          height: screenHeight*1,
          width: screenWidth*1,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(screenWidth*0.1,screenWidth*0.1,screenWidth*0.1,screenWidth*0.05),
                height: screenHeight*0.61,
                width: screenWidth*1,
                decoration: BoxDecoration(
                    color:Color.fromRGBO(225, 222, 222, 1.0),
                    border:Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(15)
                ),
                child:  currentIndex==1 ?
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[
                        index==2? Container(
                            padding: EdgeInsets.fromLTRB(0, screenWidth*0.05, 0,  screenWidth*0.05),
                            child:
                            Text(
                              total.toString()+'kW',
                              textAlign:TextAlign.center,
                              style: TextStyle(
                                fontSize:  screenWidth*0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ):index==1?Container(
                          padding: EdgeInsets.fromLTRB(0,  screenWidth*0.04 , 0,  screenWidth*0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed:(){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context)=>
                                     const loginPage()
                                    )
                                  );
                                },

                                icon: Icon(Icons.warning_sharp,
                                  color: Colors.yellowAccent,
                                size:  screenWidth*0.04,),
                              ),
                              SizedBox(
                                width:  screenWidth*0.01,
                              ),
                              Text('ABD1234 IS UNREACHABLE!',
                                style: TextStyle(
                                    fontSize:  screenWidth*0.04,
                                    fontWeight: FontWeight.bold
                                ),)
                            ],
                          ),
                        ):Container(
                            padding: EdgeInsets.fromLTRB(0,  screenWidth*0.05, 0,  screenWidth*0.05),
                            child:
                            Text(
                              total.toString()+' kW',
                              textAlign:TextAlign.center,
                              style: TextStyle(
                                fontSize:  screenWidth*0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Container(
                                margin:EdgeInsets.fromLTRB( screenWidth*0.01, screenWidth*0.01, screenWidth*0.05, screenWidth*0.01) ,
                                color:Color.fromRGBO(
                                    168, 166, 166, 1.0),
                                height: screenHeight*0.18,
                                width: screenWidth*0.3,
                                alignment: Alignment.centerLeft,
                                child:
                                Column(
                                    children:<Widget>[
                                      Text('Steam Pressure',textAlign: TextAlign.center,
                                      style: TextStyle(
                                       fontSize:  screenWidth*0.034
                                      ),),
                                      Expanded(
                                        child:
                                        SfRadialGauge(
                                          enableLoadingAnimation:true,
                                          axes:<RadialAxis> [
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
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                )
                                              ],
                                              pointers: [
                                                RangePointer(
                                                  value: pressure,
                                                  color:Colors.green ,
                                                )
                                              ],
                                              annotations: [
                                                GaugeAnnotation(
                                                  widget: Text(pressure.toString()+' bar',
                                                    style: TextStyle(
                                                      fontSize:  screenWidth*0.04
                                                    ),),
                                                  angle: 90,
                                                  positionFactor: 1.3,
                                                )
                                              ],
                                            )
                                          ],

                                        ),
                                      ),
                                    ]) ,
                              ),

                              Container(
                                color:Color.fromRGBO(
                                    168, 166, 166, 1.0),
                                height: screenHeight*0.18,
                                width: screenWidth*0.3,
                                alignment: Alignment.centerRight,
                                child:
                                Column(
                                    children:<Widget>[
                                      Text('Steam Flow',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:  screenWidth*0.034
                                      ),),
                                      Expanded(
                                        child:
                                        SfRadialGauge(
                                          enableLoadingAnimation:true,
                                          axes:<RadialAxis> [
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
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                )
                                              ],
                                              pointers: [
                                                RangePointer(
                                                  value: flow,
                                                  color:Colors.red ,
                                                )
                                              ],
                                              annotations: [
                                                GaugeAnnotation(
                                                  widget: Text(flow.toString()+' T/H',
                                                  style: TextStyle(
                                                    fontSize:  screenWidth*0.04
                                                  ),),
                                                  angle: 90,
                                                  positionFactor: 1.3,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ]) ,
                              ),
                            ]),

                        Row(
                            children:<Widget>[
                              Container(
                                margin:EdgeInsets.fromLTRB(screenWidth*0.08, screenWidth*0.02, screenWidth*0.05, screenWidth*0.01) ,
                                color:Color.fromRGBO(
                                    168, 166, 166, 1.0),
                                height:screenHeight*0.18,
                                width: screenWidth*0.3,
                                alignment: Alignment.centerLeft,
                                child:
                                Column(
                                    children:<Widget>[
                                      Text('Water Level',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: screenWidth*0.034
                                      ),),
                                      Expanded(
                                        child:
                                        SfRadialGauge(
                                          enableLoadingAnimation:true,
                                          axes:<RadialAxis> [
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
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                )
                                              ],
                                              pointers: [
                                                RangePointer(
                                                  value: water,
                                                  color:Colors.green ,
                                                )
                                              ],
                                              annotations: [
                                                GaugeAnnotation(
                                                  widget: Text(water.toString()+' %',
                                                  style: TextStyle(
                                                    fontSize: screenWidth*0.04
                                                  ),),
                                                  angle: 90,
                                                  positionFactor: 1.3,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ]) ,
                              ),

                              Container(
                                color:Color.fromRGBO(
                                    168, 166, 166, 1.0),
                                height:screenHeight*0.18,
                                width:screenWidth*0.3,
                                alignment: Alignment.centerRight,
                                child:
                                Column(
                                    children:<Widget>[
                                      Text('Power Frequency',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: screenWidth*0.034
                                      ),),
                                      Expanded(
                                        child:
                                        SfRadialGauge(
                                          enableLoadingAnimation:true,
                                          axes:<RadialAxis> [
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
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                )
                                              ],
                                              pointers: [
                                                RangePointer(
                                                  value: power,
                                                  color:Colors.green ,
                                                )
                                              ],
                                              annotations: [
                                                GaugeAnnotation(
                                                  widget: Text(power.toString()+' Hz',
                                                  style: TextStyle(
                                                    fontSize: screenWidth*0.04
                                                  ),),
                                                  angle: 90,
                                                  positionFactor: 1.3,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ]) ,
                              ),
                            ]),

                        Container(
                          padding: EdgeInsets.all(screenWidth*0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '$formattedDate',
                                style: TextStyle(
                                    fontWeight:FontWeight.bold,
                                    fontSize: screenWidth*0.04
                                ),
                              ),
                              SizedBox(
                                  width: screenWidth*0.025
                              ),
                              Text(
                                '$formattedTime',
                                style: TextStyle(
                                    fontWeight:FontWeight.bold,
                                    fontSize: screenWidth*0.04
                                ),
                              )
                            ],
                          ),
                        )
                      ] ),
                ):currentIndex==0 ?
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: context.watch<UserProvider>().nameList[context.watch<UserProvider>().indexNum-1].length,
                          itemBuilder: (context, index) =>
                            Container(
                            padding: EdgeInsets.all(screenWidth*0.01),
                            margin: EdgeInsets.all(screenWidth*0.05),
                            width: screenWidth*0.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('   '+
                                    context.watch<UserProvider>().nameList[context.watch<UserProvider>().indexNum-1][index],
                                  style: TextStyle(
                                      fontSize: screenWidth*0.05
                                  ),
                                ),
                                Text(
                                  '\u2022 ' +context.watch<UserProvider>().phoneNumberList[context.watch<UserProvider>().indexNum-1][index],
                                  style: TextStyle(
                                      fontSize: screenWidth*0.05
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                          height:20
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0,0,screenWidth*0.05,0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed:(){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:(context)=>
                                    const invitationPage(),
                                  ),
                                );
                              },

                              iconSize: screenWidth*0.1,
                              padding: EdgeInsets.fromLTRB(0, 0, screenWidth*0.01, screenWidth*0.03),
                              color:Colors.black ,
                              icon: Icon(
                                Icons.add,
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>
                                    (
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(17),
                                          side: BorderSide(
                                            color: Colors.white,
                                          )
                                      )
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>
                                    (
                                      Color.fromRGBO(245, 112, 245, 1.0)
                                  ),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(screenWidth*0.1,screenWidth*0.1),
                                  )
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                ):Container(
                  child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0,screenWidth*0.05, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width:25,
                              ),
                              Text('Minimum Threshold',
                                style: TextStyle(
                                    fontSize: screenWidth*0.04,
                                    fontWeight: FontWeight.bold
                                ),),
                              SizedBox(
                                  width:10
                              ),
                              IconButton(
                                onPressed:(){},
                                icon: Icon(
                                    Icons.info_outline_rounded,
                                    size: screenWidth*0.04,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              IconButton(
                                onPressed:(){
                                  setState(() {
                                    write=true;
                                  });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.deepPurple,
                                  size: screenWidth*0.04,
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          side: BorderSide(
                                            color: Colors.white,
                                          ),
                                        )
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(screenWidth*0.08, screenWidth*0.06)
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin:EdgeInsets.fromLTRB(0,screenWidth*0.05,0,0),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(10,10, 0,10),
                                        child: Text('Steam Pressure',
                                          style: TextStyle(
                                              fontSize: screenWidth*0.03,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ),
                                      Container(
                                        width:screenWidth*0.3,
                                        height:screenWidth*0.2,
                                        padding: EdgeInsets.all(5),
                                        margin:EdgeInsets.fromLTRB(10,10, 0, 10),

                                        child:
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                enabled: write,
                                                controller: textEditingController1,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: screenWidth*0.03,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                  width:screenWidth*0.01,
                                                  height:screenHeight*0.06,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color:Colors.black
                                                      )
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'bar',
                                                      style:TextStyle(
                                                          fontSize: screenWidth*0.04,fontWeight: FontWeight.bold
                                                      ) ,
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
                                margin:EdgeInsets.fromLTRB(screenWidth*0.05,screenWidth*0.05,screenWidth*0.05,0),
                                alignment: Alignment.centerRight,
                                child: Column(
                                    children: [
                                      Container(
                                        margin:EdgeInsets.fromLTRB(10,10, 0, 10) ,
                                        child: Text('Steam Flow',
                                          style: TextStyle(
                                              fontSize: screenWidth*0.03,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ),
                                      Container(
                                        width:screenWidth*0.3,
                                        height:screenWidth*0.2,
                                        padding: EdgeInsets.all(5),
                                        margin:EdgeInsets.fromLTRB(10,10, 0, 10),

                                        child:
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: textEditingController2,
                                                enabled: write,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: screenWidth*0.03,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                  width:screenWidth*0.04,
                                                  height:screenHeight*0.06,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color:Colors.black
                                                      )
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'T/H',
                                                      style:TextStyle(
                                                          fontSize: screenWidth*0.04,fontWeight: FontWeight.bold
                                                      ) ,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(10,10, 0, 10),
                                        child: Text('Water Level',
                                          style: TextStyle(
                                              fontSize: screenWidth*0.03,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ),
                                      Container(
                                        width:screenWidth*0.3,
                                        height:screenWidth*0.2,
                                        padding: EdgeInsets.all(5),
                                        margin:EdgeInsets.fromLTRB(10,10, 0, 10),

                                        child:
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                enabled: write,
                                                controller: textEditingController3,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: screenWidth*0.03,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,

                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                  width:screenWidth*0.04,
                                                  height:screenHeight*0.06,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color:Colors.black
                                                      )
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '%',
                                                      style:TextStyle(
                                                          fontSize: screenWidth*0.04,fontWeight: FontWeight.bold
                                                      ) ,
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
                                margin:EdgeInsets.fromLTRB(screenWidth*0.05,0,screenWidth*0.01,0),
                                alignment: Alignment.centerRight,
                                child: Column(
                                    children: [
                                      Container(
                                        margin:EdgeInsets.fromLTRB(10,10, 0, 10) ,
                                        child: Text('Power Frequency',
                                          style: TextStyle(
                                              fontSize: screenWidth*0.03,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ),
                                      Container(
                                        width:screenWidth*0.3,
                                        height:screenWidth*0.2,
                                        padding: EdgeInsets.all(5),
                                        margin:EdgeInsets.fromLTRB(10,10, 0, 10),

                                        child:
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: textEditingController4,
                                                enabled: write,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: screenWidth*0.03,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,

                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                  width:screenWidth*0.04,
                                                  height:screenHeight*0.06,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color:Colors.black
                                                      )
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Hz',
                                                      style:TextStyle(
                                                          fontSize: screenWidth*0.04,fontWeight: FontWeight.bold
                                                      ) ,
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
                                          write==true?
                                          ElevatedButton(
                                              key:Key('save'),
                                              onPressed: (){
                                                setState(() {
                                                  write=false;
                                                });
                                              },
                                              child: Text('Save',
                                              style: TextStyle(
                                                fontSize: screenWidth*0.04
                                              ),)):Container()
                                        ],
                                      )
                                    ]
                                )
                            ),
                          ],
                        ),
                      ]
                  ),
                ) ,
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    margin: EdgeInsets.fromLTRB(45, 0, 75, screenWidth*0.04),
                    child:
                    Row(
                      children: [
                        IconButton(
                          onPressed:(){
                            setState(() {
                              index=1;
                              pressure=0;
                              flow=0;
                              water=0;
                              power=0;
                              formattedDate = '--';
                              formattedTime = '--';
                              context.read<UserProvider>().change2(newIndex: index);
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                          } ,

                          padding: EdgeInsets.all(15),
                          iconSize: screenWidth*0.1,
                          color: Colors.black,
                          icon: Column(
                            children: [
                              Icon(
                                  Icons.factory
                              ),
                              Text('Factory 1',
                              style: TextStyle(
                                fontSize: screenWidth*0.04
                              ),)
                            ],
                          ),
                          style:ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: index==1 ?Colors.blue :Colors.white,
                                    ),
                                  )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(232, 228, 228, 1.0),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(screenWidth*0.25,screenWidth*0.25),
                              )
                          ),
                        ),

                        SizedBox(
                          width: 40,
                        ),

                        IconButton(
                          onPressed:(){
                            setState(() {
                              index=2;
                              total=1549.7;
                              pressure=34.19;
                              flow=22.82;
                              water=55.41;
                              power=50.08;
                              DateTime now = DateTime.now();
                              formattedDate = DateFormat('yyyy-MM-dd').format(now);
                              formattedTime = DateFormat('HH:mm:ss').format(now);
                              context.read<UserProvider>().change2(newIndex: index);
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                          } ,
                          padding: EdgeInsets.all(15),
                          iconSize: screenWidth*0.1,
                          color: Colors.black,
                          icon: Column(
                            children: [
                              Icon(
                                  Icons.factory
                              ),
                              Text('Factory 2',
                              style: TextStyle(
                                fontSize: screenWidth*0.04
                              ),)
                            ],
                          ),
                          style:ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: index==2 ?Colors.blue :Colors.white,
                                    ),
                                  )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(232, 228, 228, 1.0),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(screenWidth*0.25,screenWidth*0.25),
                              )
                          ),
                        ),

                        SizedBox(
                          width: 40,
                        ),

                        IconButton(
                          onPressed:(){
                            setState(() {
                              index=3;
                              pressure=0;
                              flow=0;
                              water=0;
                              power=0;
                              formattedDate = '--';
                              formattedTime = '--';
                              total=0;
                              context.read<UserProvider>().change2(newIndex: index);
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                          } ,
                          padding: EdgeInsets.all(15),
                          iconSize: screenWidth*0.1,
                          color: Colors.black,
                          icon: Column(
                            children: [
                              Icon(
                                  Icons.factory
                              ),
                              Text('Factory 3',
                              style: TextStyle(
                                fontSize: screenWidth*0.04
                              ),)
                            ],
                          ),
                          style:ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: index==3 ?Colors.blue :Colors.white,
                                    ),
                                  )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(232, 228, 228, 1.0),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(screenWidth*0.25,screenWidth*0.25),
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
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          )
        ],
        currentIndex: currentIndex,
        onTap: (int index)
        {
          setState(() {
            currentIndex=index;
          });
        },
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
