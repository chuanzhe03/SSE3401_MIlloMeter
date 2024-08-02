import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lab_5_2/home.dart';
import 'package:lab_5_2/model/contact_model.dart';
import 'package:lab_5_2/services/api.dart';
import 'package:lab_5_2/user_provider.dart';
import 'package:provider/provider.dart';

class invitationPage extends StatefulWidget {
  const invitationPage( {super.key});

  @override
  State<invitationPage> createState() => _invitationPageState();
}

class _invitationPageState extends State<invitationPage> {
  TextEditingController textEditingController1=TextEditingController();
  String phoneNumber='';
  late Api api=Api();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    int index=context.watch<UserProvider>().indexNum;
    late Future<List<ContactData>> futureContact=api.fetchContact(index);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Factory '+context.watch<UserProvider>().indexNum.toString(),
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          color:Color.fromRGBO(213, 205, 205, 1.0),
          height: screenHeight*1,
          padding: EdgeInsets.fromLTRB(0, screenWidth * 0.2, 0, 0),
          child:
          Column(
            children: [
              Text('Invitation',
                style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold
                ),),
        
              Text(
                'Invite users',
                style: TextStyle(
                    fontSize: screenWidth * 0.045
                ),
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.08,screenWidth * 0.04,screenWidth * 0.08,screenWidth * 0.04),
                      child:
                      Text('Owner\'s users',
                        style: TextStyle(
                            fontSize: screenWidth * 0.06
                        ),)
                  )
                ],
              ),
        
              Container(
                width: screenWidth * 0.8,
                child: TextField(
                  key: Key('Text field'),
                   controller: textEditingController1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: 'Type here',
                        hintStyle: TextStyle(
                          fontSize: screenWidth * 0.04
                        ),
                        filled: true,
                        fillColor: Colors.white
                    )
                ),
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.08,screenWidth * 0.04,screenWidth * 0.08,screenWidth * 0.04),
                      child:
                      Text('Owner\'s Phone Number',
                        style: TextStyle(
                            fontSize: screenWidth * 0.06
                        ),)
                  )
                ],
              ),
        
              Container(
                width: screenWidth * 0.8,
                child: IntlPhoneField(
                  key: Key('phone'),
                  onChanged: (phone) {
                    setState(() {
                      phoneNumber = phone.completeNumber;
                    });
                  },

                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: 'Enter your phone number',
                      hintStyle: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                      fillColor: Colors.white,
                      filled: true
                  ),
                ),
              ),
        
              Container(
                width: 300,
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  key: Key('button'),
                    onPressed: (){
                      context.read<UserProvider>().change(newName: textEditingController1.text, newPhone: phoneNumber);
                      FocusManager.instance.primaryFocus?.unfocus();

                      var data1 = {
                        "name": textEditingController1.text,
                        "role": 'admin',
                        "factory": Provider.of<UserProvider>(context, listen: false).indexNum.toString(),
                        "phoneNumber": phoneNumber,
                      };
                      Api.addContact(data1);

                      var data2 = {
                        "phoneList": phoneNumber,
                      };
                      Api.addPhoneList(data2);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const firstPage()),
                      ).then((_) {
                        setState(() {
                          futureContact = api.fetchContact(index);
                        });
                      });

                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurpleAccent
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white
                        )
                    ),
                    child:Text('Submit',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06
                    ),)
                ),
              )
        
            ],
          ),
        
        
        ),
      ),
    );
  }
}