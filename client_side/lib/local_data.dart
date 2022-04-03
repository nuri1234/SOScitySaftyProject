import 'package:shared_preferences/shared_preferences.dart';
class data{
  static String phone="non";
  static bool phon_verfyed=false;
  static bool anonymous=true;
  static String user_name="guest";
  static bool first_time=true;


  static  getData() async{
    final prefs = await SharedPreferences.getInstance();
    phon_verfyed= prefs.getBool('phon_verfyed') ?? false;
    phone= prefs.getString('phone') ?? "non";
    first_time= prefs.getBool('first_time') ?? true;
    user_name= prefs.getString('user_name')?? "guest";

  }

  static initData() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phon_verfyed');
    await prefs.remove('phone');
    await prefs.remove('first_time');
  }



  static updateData() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('phon_verfyed', phon_verfyed ?? false);
    await prefs.setString('phone', phone ?? "");
    await prefs.setBool('first_time',first_time ?? true);
    await prefs.setBool('anonymous', anonymous ?? true);
    await prefs.setString('user_name', phone ?? "guest");


  }




}