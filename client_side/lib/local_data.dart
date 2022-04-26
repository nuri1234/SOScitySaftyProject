import 'package:shared_preferences/shared_preferences.dart';
class data{
  static String phone="non";
  static bool phone_verified=false;
  static String user_name="guest";
  static bool first_time=true;
  static bool arabic=false;
  static int language=0;


  static  getData() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('phone_verified')!=null) phone_verified=prefs.getBool('phone_verified')!;
    if(prefs.getString('phone')!=null)phone= prefs.getString('phone')!;
    if(prefs.getBool('first_time')!=null) first_time= prefs.getBool('first_time')!;
    if(prefs.getBool('arabic')!=null) arabic= prefs.getBool('arabic')!;
    if(prefs.getString('user_name')!=null)user_name= prefs.getString('user_name')!;
    if(prefs.getInt('language')!=null)language= prefs.getInt('language')!;

  }

  static RestartData() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone_verified');
    await prefs.remove('phone');
    await prefs.remove('first_time');

  }



  static updateData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('phone_verified', phone_verified);
    await prefs.setString('phone', phone);
    await prefs.setBool('first_time', first_time);
    // await prefs.setBool('anonymous', anonymous );
    await prefs.setString('user_name', user_name);
    await prefs.setBool('arabic', arabic);
    await prefs.setInt('language',language);
  }



}