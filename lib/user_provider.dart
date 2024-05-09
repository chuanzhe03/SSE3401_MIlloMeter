
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<List<String>> nameList = [['Ben','Testing 1'],['Testing 2'],['World']];
  List<List<String>> phoneNumberList = [['+60109219938','+601234567891'],['+601321654987'],['+601789654321']];
  int indexNum = 1;

  void change({
    required String newName,
    required String newPhone,
  }) async {
    nameList[indexNum-1].add(newName);
    phoneNumberList[indexNum-1].add(newPhone);
    notifyListeners();
  }

  void change2({
    required int newIndex
  }) async {
    indexNum = newIndex;
  }

}


