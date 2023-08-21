import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  String _userName = '';
  String _serviceid = " ";

  String _name= '';

  String get userName => _userName;
  String get servideid => _serviceid;
  String get name => _name;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

   void setServiceId(String name) {
    _serviceid = name;
    notifyListeners();
  }
   void setName(String name) {
    _name = name;
    notifyListeners();
  }
}
