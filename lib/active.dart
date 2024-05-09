import 'package:flutter/material.dart';
import 'package:lab_5_2/home.dart';
import 'package:lab_5_2/main.dart';

class activePage extends StatefulWidget {
  const activePage({super.key});

  @override
  State<activePage> createState() => _activePageState();
}

class _activePageState extends State<activePage> {

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body:SingleChildScrollView(
          child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/img.png',
              width: screenWidth * 0.4,
              height: screenWidth * 0.4,),

            Container(
              margin: EdgeInsets.fromLTRB(18, 0, 0, 18),
              child: Text(
                'Welcome !',
                style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06
                ) ,
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(18, 0, 0, 18),
              padding: EdgeInsets.fromLTRB(18,15,12, 0),
              width: screenWidth * 0.8,
              height: screenHeight*0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(220, 216, 216, 1.0),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        width: screenWidth * 0.55,
                        child: Text('Enter the activation code you received via SMS.',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04
                          ),),
                      ),

                      IconButton(
                          onPressed: (){},
                          icon: Icon(
                              Icons.info_outline_rounded,
                              size:  screenWidth * 0.09,
                          )
                      ),
                    ],
                  ),

                  Container(
                     margin: EdgeInsets.fromLTRB(25,25,25,10),
                     padding: EdgeInsets.fromLTRB(screenWidth * 0.04,screenWidth * 0.01,screenWidth * 0.04,screenWidth * 0.01),
                     child: TextField(
                       keyboardType: TextInputType.number,
                       decoration: InputDecoration(
                         border: OutlineInputBorder(
                             borderSide: BorderSide(
                               color: Colors.black,
                             ),
                             borderRadius: BorderRadius.circular(10)
                         ),
                         hintText: 'OTP',
                         hintStyle: TextStyle(
                             fontSize: screenWidth * 0.03,
                         )
                       ),
                       maxLength: 6,
                       textAlign: TextAlign.center,
                     ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Didn\'t receive?',
                        style: TextStyle(
                            fontSize:screenWidth * 0.03
                        ),),

                      TextButton(
                          onPressed:(){
                            Navigator.of(context).pop(
                              MaterialPageRoute(builder: (context)=>
                                  const loginPage()
                              )
                            );
                          },
                          child: Text(
                            'Tap here',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              decoration: TextDecoration.underline,
                              color: Colors.blueAccent
                            ),
                          )
                      )
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>
                                  const firstPage()
                                  )
                              );
                            },
                            child:Text('Activate',
                            style: TextStyle(
                              fontSize:screenWidth * 0.04
                            ),)
                        ),
                      ],
                    ),
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
                            fontSize:screenWidth * 0.04
                        ),
                      )),

                  TextButton(
                      onPressed:(){},
                      child: Text(
                        'Privacy Statement',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            fontSize:screenWidth * 0.04
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
                  style: TextStyle(
                      fontSize:screenWidth * 0.03
                  ),),
                  Text('CCS Sdn.Bhd',
                  style: TextStyle(
                      fontSize:screenWidth * 0.03
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
