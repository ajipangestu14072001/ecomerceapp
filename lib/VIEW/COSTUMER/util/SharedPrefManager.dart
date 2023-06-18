import 'package:shared_preferences/shared_preferences.dart';


  void saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

 void saveUserData(String userId, String userName, String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', userId);
  prefs.setString('userName', userName);
  prefs.setString('name', name);
}

void saveIdHistory(String idHistory, String sum) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('idHistory', idHistory);
  prefs.setString('sum', sum);
}