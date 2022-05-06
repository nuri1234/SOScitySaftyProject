import 'package:flutter/material.dart';
import 'colors.dart';
class my_texts {
  static String CitySafty = "City Safety";
  static String welcome = "Welcome to";
  static String home_page = "home page";
  static String connectedToServer="CONNECTED TO SERVER ";
  static String NotconnectedToServer="NOT CONNECTED TO SERVER";
  static String userName="userName";
  static String phone="phone";
  static String date="date";
  static String time="time";
  static String location="location";
  static String clientConnected="client connected";
  static String canceled="canceled";
  static String clientDisconnected="client disconnected";
  static String topic="topic";
  static String description="description";
  static String contactsByMonth="Number of contacts per month";
  static String contactsByYear="Number of contacts per year";
  static String contactsByLocation="Number of contacts per locatin";
  static String count="count";
  static String month="month";
  static String perYear="per year";
  static String perMonth="per month";
  static String perLocation="per location";
  static String allContacts="all contacts";
  static String city="city";
  static String street="street";
  ///////////////////////////////
  static String workerUserName="center";


  static changeToEnglish(){
    city="city";
   street="street";
   workerUserName="center";
    allContacts="all contacts";
    contactsByLocation="Number of contacts per locatin";
    perYear="per year";
    perLocation="per location";
     perMonth="per month";
    month="month";
    count="count";
    contactsByYear="Number of contacts per year";
    contactsByMonth="Number of contacts per month";
    connectedToServer="CONNECTED TO SERVER ";
    NotconnectedToServer="NOT CONNECTED TO SERVER";
    userName="userName";
    phone="phone";
    date="date";
    time="time";
    location="location";
    clientConnected="client connected";
    canceled="canceled";
    clientDisconnected="client disconnected";
    topic="topic";
    description="description";



  }

  static changeToHebrew(){
    city="עיר";
    street="רחוב";
    workerUserName="מוקדן";
    allContacts="כל הפניות";
    contactsByLocation="מספר פניות לפי מיקום";
    perLocation="לפי מיקום";
    perYear="לפי שנה";
    perMonth="לפי חודש";
    contactsByYear="מספר פניות לפי שנה";
    month="חודש";
    count="כמות";
    contactsByMonth="מספר פניות לפי חודש";
   connectedToServer="מחובר לשרת";
    NotconnectedToServer="מנותק מהשרת";
    userName="שם משתמש";
    phone="טלפון";
    date="תאריך";
   time="שעה";
    location="מיקום";
     clientConnected="הלקוח מחובר";
    canceled="הלקוח סגר את הפנייה";
    clientDisconnected="הלקוח התנתק";
     topic="סוג פנייה";
    description="תיאור הפנייה";



  }
  static changeToArabic(){
    city="مدينة";
    street="شارع";
    workerUserName="اسم الموظف";
    allContacts="كل التوجهات";
    contactsByLocation="عدد التوجهات وفقا للموقع";
    perLocation="وفقا للموقع";
    perYear="وفقا للسنة ";
    perMonth="وفقا للشهر";
    contactsByYear="عدد التوجهات وفقا للسنة";
    month="شهر";
    count="كمية";
    contactsByMonth="عدد التوجهات وفقا للشهر";
    connectedToServer="متصل بالخادم";
    NotconnectedToServer="غير متصل بالخادم";
    userName="اسم المستخدم";
    phone="رقم الهاتف";
    date="تاريح";
    time="ساعة";
    location="موقع";
    clientConnected="المواطن متصل";
    canceled="المواطن اغلق التوجه";
    clientDisconnected="المواطن قطع الاتصال";
    topic="نوع التوجه";
    description="شرح التوجه";
  }



  static getMonthInEnglish(int month){
    switch(month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }




  }
  static getMonthInHebroe(int month){
    switch(month) {
      case 1:
        return "ינואר";
      case 2:
        return "פברואר";
      case 3:
        return "מרץ";
      case 4:
        return "אפריל";
      case 5:
        return "מאי";
      case 6:
        return "יוני";
      case 7:
        return "יולי";
      case 8:
        return "אוגוסט";
      case 9:
        return "ספטמבר";
      case 10:
        return "אוקטובר";
      case 11:
        return "נובמבר";
      case 12:
        return "דיצמבר";
    }




  }
  static getMonthInArabic(int month){
    switch(month) {
      case 1:
        return "كَانُون ٱلثَّانِي";
      case 2:
        return "شُبَاط";
      case 3:
        return "اذَار";
      case 4:
        return "نَيْسَان";
      case 5:
        return "أَيَّار";
      case 6:
        return "حَزِيرَان";
      case 7:
        return "تَمُّوز";
      case 8:
        return "آب";
      case 9:
        return "أَيْلُول";
      case 10:
        return "تِشْرِين ٱلْأَوَّل";
      case 11:
        return "تِشْرِين ٱلثَّانِي	";
      case 12:
        return "كَانُون ٱلْأَوَّل";
    }




  }













}











