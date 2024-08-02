import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:lab_5_2/model/averageThreshold_model.dart';
import 'package:lab_5_2/model/contact_model.dart';
import 'package:lab_5_2/model/maxThreshold_model.dart';
import 'package:lab_5_2/model/minThreshold_model.dart';
import 'package:lab_5_2/model/phoneNumberList_model.dart';
import 'package:lab_5_2/model/factory_model.dart';

class Api {
  static const baseUrl = "http://10.0.2.2:3000/api/";

  static addMinThreshold(Map pdata) async {
    var url = Uri.parse("${baseUrl}addMinThreshold");
    try {
      final res = await http.post(url, body: pdata);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      }
      else {
        print("Failed to get response");
      }
    }
    catch (e) {
      debugPrint(e.toString());
    }

  }

  Future<MinThreshold> fetchMinThreshold(String id) async {
    final response = await http.get(Uri.parse('${baseUrl}getMinThreshold/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return MinThreshold.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load ');
    }
  }


  static addContact(Map pdata) async {
    var url = Uri.parse("${baseUrl}addContact");
    try {
      final res = await http.post(url, body: pdata);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      }
      else {
        print("Failed to get response");
      }
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }

  static addPhoneList(Map pdata) async {
    var url = Uri.parse("${baseUrl}addPhoneList");
    try {
      final res = await http.post(url, body: pdata);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      }
      else {
        print("Failed to get response");
      }
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<PhoneNumberList>> fetchPhoneLists() async {
    final response = await http.get(Uri.parse('${baseUrl}getPhoneList'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => PhoneNumberList.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load phone lists');
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('${baseUrl}send-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      print('OTP sent successfully');
    } else {
      throw Exception('Failed to send OTP');
    }
  }

  Future<http.Response> verifyOtp(String phoneNumber, String code) async {
    final response = await http.post(
      Uri.parse('${baseUrl}verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      print('OTP verified successfully');
    } else {
      print('Failed to verify OTP: ${response.body}');
      throw Exception('Failed to verify OTP');
    }
    return response;
  }

  Future<MinThreshold> updateMinThreshold(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("${baseUrl}update/$id"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return MinThreshold.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to update');
    }
  }

  Future<List<FactoryData>> fetchFactory(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}getFactory?factory=$id'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => FactoryData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load factory');
    }
  }

  Future<List<ContactData>> fetchContact(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}getContact?factory=$id'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ContactData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load contact');
    }
  }

  Future<List<ContactData>> fetchOwner(int id,String number) async {
    final response = await http.get(Uri.parse('${baseUrl}getOwner?factory=$id&phoneNumber=%2B$number'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ContactData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> sendNotification(String phoneNumber,String message) async {
    final response = await http.post(
      Uri.parse('${baseUrl}notify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'message': message
      }),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      throw Exception('Failed to send notification');
    }
  }

  Future<List<MaxThreshold>> fetchMaxThreshold(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}getMaxThreshold?factory=$id'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => MaxThreshold.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load ');
    }
  }

  Future<List<AverageThreshold>> fetchAverageThreshold(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}getAverageThreshold?factory=$id'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => AverageThreshold.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load ');
    }
  }

  Future<List<MinThreshold>> getMinThreshold(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}getMin1Threshold?factory=$id'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => MinThreshold.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load ');
    }
  }

  Future<List<FactoryData>> getFactory(int id,String date) async {
    final response = await http.get(Uri.parse('${baseUrl}getFactoryData?factory=$id&date=$date'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => FactoryData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load factory');
    }
  }
}
