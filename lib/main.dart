import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lab_5_2/active.dart';
import 'package:lab_5_2/model/phoneNumberList_model.dart';
import 'package:lab_5_2/services/api.dart';
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Factory',
        home: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBoxValue = false;
  TextEditingController textEditingController1 = TextEditingController();
  String phoneNumber = '';
  late Api api = Api();
  late Future<List<PhoneNumberList>> futurePhoneLists;
  bool isUserFound = false;

  Future<void> _sendOtp() async {
    try {
      await api.sendOtp(phoneNumber);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    futurePhoneLists = api.fetchPhoneLists();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/img.png',
                width: screenWidth * 0.4,
                height: screenWidth * 0.4,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 0, 18),
                child: Text(
                  'Welcome !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 0, 18),
                padding: const EdgeInsets.fromLTRB(18, 15, 12, 0),
                width: screenWidth * 0.8,
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(243, 143, 192, 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth * 0.55,
                          child: Text(
                            'Enter your mobile number to activate your account.',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.info_outline_rounded,
                            size: screenWidth * 0.09,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      width: screenWidth * 0.8,
                      child: IntlPhoneField(
                        controller: textEditingController1,
                        onChanged: (phone) {
                          setState(() {
                            phoneNumber = phone.completeNumber;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          tristate: false,
                          value: checkBoxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              checkBoxValue = value!;
                            });
                          },
                        ),
                        Text(
                          'I agree to the terms & conditions ',
                          style: TextStyle(fontSize: screenWidth * 0.039),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenWidth * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (checkBoxValue == true &&
                                textEditingController1.text.isNotEmpty) {
                              try {
                                final phoneLists = await futurePhoneLists;
                                bool userFound = phoneLists.any((phoneList) => phoneList.phoneList == phoneNumber,
                                );
                                if (userFound) {
                                  isUserFound = true;
                                  context.read<UserProvider>().change3(newPhone: phoneNumber);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const activePage(),
                                    ),
                                  );
                                  _sendOtp();
                                } else {
                                  setState(() {
                                    isUserFound = false;
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  isUserFound = false;
                                });
                              }

                              if (!isUserFound){
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context){
                                return Container(
                                  margin: const EdgeInsets.all(16),
                                  width: screenWidth * 1,
                                  child: Text(
                                    'Phone number not registered',
                                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                );
                              });
                              }
                            }
                          },
                          child: Text(
                            'Get Activation Code',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ],
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Disclaimer',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Privacy Statement',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Copyright UPM & Kejuruteraan Minyak Sawit ',
                      style: TextStyle(fontSize: screenWidth * 0.03),
                    ),
                    Text(
                      'CCS Sdn.Bhd',
                      style: TextStyle(fontSize: screenWidth * 0.03),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
