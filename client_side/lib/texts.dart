import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
class my_texts {
  static String username="username";

  static String CitySafty = "SOS City Safety";
  static String select_image = "select image";
  static String delet_image = "delete image";
  static String cancel = "cancel";
  static String continue_bot = "Continue";
  static String SOS = "SOS";
  static String welcome = "Welcome to";
  static String home_page = "home page";
  static String registration= "registration";
  static String EnterPhon= "Please enter your phone number ";
  static String Next= "Next";
  static String phoneNumber= "phone number";
  static String phone_verification= "phone verification";
  static String anonymous= "anonymous";
  static String non_anonymous= "non anonymous";
  static String try_again= "try again";
  static String enter_name= "enter tour name";
  static String connectedToServer="CONNECTED TO SERVER ";
  static String NotconnectedToServer="NOT CONNECTED TO SERVER";
  static String sentReferral="The SOS referral has been sent";
  static String sosReceived="The SOS referral has been Received";
  static String fillyourdetails="fill you details";
  static String inputPhone="input phone";
  static String inputDescription="description";
  static String enterYourMessage="your message";
  static String centerDissconected="center Dissconected";
  static String endCall="this contact is ended";
  static String endContact="end Contact";
  static String  centerInactive="center inactive";
  static Text explaneText= Text("The details you enter now are saved only locally .Only when an SOS call is made the application will use the data. The data can be changed in any time",
  style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black),);
  static const TextStyle buttonTextStyle=TextStyle(fontSize: 18,color:Colors.white);

  static String phone_verification_complete= "phone verification complete";
  static String phone_verification_not_complete ="phone verification not Succeed";

  static changeToArabic(){
    username="اسم المستخدم";
    inputPhone="ادخل رقم الهات";
    explaneText=Text("المعلومات التي ستقوم بادخالها سيتم حفظها محليا, اي ان لن يتم استخدامها الا في حالة استخدام التطبيق لطلب المساعدة , المعلمومات يتم تغييرها  في اي وقت",
      style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black),);
    EnterPhon= "الرجاء ادخال رقم الهاتف";
    Next= "التالي";
    phoneNumber= "رقم الهاتف";
    phone_verification= " تأكيد رقم الهاتف";
    phone_verification_complete= "اكتمل التحقق من رقم الهاتف";
    phone_verification_not_complete ="التحقق من الهاتف لا ينجح";
    centerInactive="مركز غير نشط";


    try_again= "حاول مجددا";
    enter_name= "ادخال الاسم الشخصي" ;
 connectedToServer="متصل بالخادم" ;
  NotconnectedToServer="غير متصل بالخادم";


    inputDescription="شرح  الحالة";

    enterYourMessage="رسالتك";
    centerDissconected="المركز متصل" ;
    endCall="تم قطع الاتصال";
    endContact="تطبيق وثيقة";


  }

  static changeEnglish(){

    phone_verification_not_complete ="phone verification not Succeed";
    phone_verification_complete= "phone verification complete";
    username="username";
    cancel = "cancel";
    continue_bot = "Continue";
   home_page = "home page";
    registration= "registration";
    EnterPhon= "Please enter your phone number ";
     Next= "Next";
    phoneNumber= "phone number";
    phone_verification= "phone verification";
     try_again= "try again";
    enter_name= "enter tour name";
     connectedToServer="CONNECTED TO SERVER ";
     NotconnectedToServer="NOT CONNECTED TO SERVER";
   sentReferral="The SOS referral has been sent";
    sosReceived="The SOS referral has been Received";
    fillyourdetails="fill you details";
   inputPhone="input phone";
    inputDescription="description";
    enterYourMessage="your message";
    centerDissconected="center Dissconected";
    centerInactive="center inactive";
    endCall="this contact is ended";
  endContact="end Contact";

     explaneText= Text("The details you enter now are saved only locally .Only when an SOS call is made the application will use the data. The data can be changed in any time",
      style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black),);

  }


  static changeToHebrew(){
    phone_verification_not_complete ="אימות הטלפון לא הצליח";;
    phone_verification_complete= "אימות הטלפון הושלם";
    username="שם משתמש";
    cancel = "ביטול";
    continue_bot = "המשך";
    EnterPhon="הכנס מספר טלפון";
    Next= "הבא";
    phoneNumber= "מספר טלפון";
    phone_verification= "אימות מספר טלפון";
    try_again= "נסה שוב";
    enter_name= "הכנס שם משתמש";
    connectedToServer="מחובר לשרת";
    NotconnectedToServer="מנותק מהשרת";
    sentReferral="נשלחה פנייה";
    sosReceived="הפנייה התקבלה";
    fillyourdetails="מלא פרטים";
    inputPhone="הכנס מספר טלפון";
    inputDescription="תיאור";
    enterYourMessage="הודעה";
    centerDissconected="המוקדן התנתק";
    endCall="הפנייה נסגרה";
    endContact="סגור פנייה";
    centerInactive="המוקד לא פעיל";

    explaneText= Text("הפרטים שאתה מכניס נשמרים באופן מקומי בלבד. רק לאחר קריאת החירום הפרטים נשלחים.ניתן לשנות את הפרטים בכל זמן",
      style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black),);

  }

}







