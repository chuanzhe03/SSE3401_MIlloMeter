import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lab_5_2/active.dart';
import 'package:lab_5_2/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create:(context)=>UserProvider()
        )
      ],
      child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Factory',
          home:loginPage()
      ),
    );
  }
}

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool checkBoxValue=false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/img.png',
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(18, 0, 0, 18),
                  child: Text(
                    'Welcome !',
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06,
                    ) ,
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(18, 0, 0, 18),
                  padding: EdgeInsets.fromLTRB(18, 15, 12, 0),
                  width: screenWidth * 0.8,
                  height: screenHeight*0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(243, 143, 192, 1.0),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth * 0.55,
                            child: Text('Enter your mobile number to activate your account.',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04
                              ),),
                          ),

                          IconButton(
                              onPressed: (){},
                              icon: Icon(
                                  Icons.info_outline_rounded,
                                size: screenWidth * 0.09,
                              )
                          ),
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        width: screenWidth * 0.8,
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Checkbox(
                            tristate: false,
                            value:checkBoxValue,
                            onChanged:(bool? value){
                              setState(() {
                                checkBoxValue=value! ;
                              });
                            },
                          ),

                          Text('I agree to the terms & conditions ',
                            style: TextStyle(
                                fontSize: screenWidth * 0.039
                            ),),
                        ],
                      ),

                      SizedBox(
                        height: screenWidth * 0.05,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                checkBoxValue==true?
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context)=>
                                    const activePage()
                                    )
                                ):loginPage();
                              },
                              child:Text('Get Activation Code',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04
                              ),)
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed:(){},
                          child: Text(
                            'Disclaimer',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                                fontSize: screenWidth * 0.04
                            ),
                          )),

                      TextButton(
                          onPressed:(){},
                          child: Text(
                            'Privacy Statement',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                                fontSize: screenWidth * 0.04
                            ),
                          )),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(30,0,0,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Copyright UPM & Kejuruteraan Minyak Sawit ',
                        style:TextStyle(
                            fontSize: screenWidth * 0.03
                        ) ,),
                      Text('CCS Sdn.Bhd',
                      style: TextStyle(
                          fontSize: screenWidth * 0.03
                      ),)
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
