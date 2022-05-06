
import 'package:center_side/compount/texts.dart';
import 'package:center_side/statistic/allContacts.dart';
import 'package:flutter/material.dart';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/dbHelper/contacts_managment.dart';
import 'package:center_side/dbHelper/contacts_model.dart';
import 'statisticByMonth.dart';
import 'package:center_side/uses/share_data.dart';
import 'statisticByYear.dart';
import 'statisticByLocation.dart';




class Statistic extends StatefulWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  final String todayYear=DateTime.now().toString().substring(0,4);

  late List<Contact> contacts;
  List<Map<String,dynamic>> _months=[];
  List<Map<String,dynamic>> _years=[];
  List<Map<String,dynamic>> _locations=[];
  int state=-1; //1-perMonth 2-perYear 3-perPlace


   makeSTbyMonth(){
    for (var i = 1; i <= 12; i++){
      _months.add({"month":i,"count":0});
    }
  //  for(var m in _months) print(m);
  }
  void foundSTbyMonth(){
    print("foundSTbyMonth() today year=$todayYear");
    for(Contact c in contacts){
      if(c.year==todayYear){
        c.printTimeAndPlace();
        int month=int.parse(c.month);
        final index = _months.indexWhere((element) => element["month"] == month);
        _months[index]['count']++;
        // print(_months[index]);
      }

    }

  }
  makeSTbyYear(){
     print("makeSTbyYear()");
     int year=int.parse(todayYear);
    for (int i = year; i >year-5; i--){
      _years.add({"year":i,"count":0});
    }
     for(var m in _years) {
       print(m);
     }

  }
  void foundSTbyYear(){
    print("foundSTbyYear() today year=$todayYear");
    int year=int.parse(todayYear);
    for(Contact c in contacts){
      int cYear=int.parse(c.year);
      if(cYear>year-5){
        c.printTimeAndPlace();
     //   print(c.year);
        for(var e in _years){
          if(e["year"]==cYear)e["count"]++;
        }
        print("foundSTbyYear()c");

      }
      print("foundSTbyYear()5");

    }

  }

  makeSTbyLocation(){

    print("makeSTbyLocatin/////////////////////////()");
    for(Contact c in contacts){
      String street=c.street;
      if(c.street.contains(new RegExp(r'[A-Z]')) ) {
        String street=c.street.replaceAll(RegExp('[0-9]'), '');
      }
      print(street);

      bool exists = _locations.any((element) => element["city"]==c.city && element["street"]==street);

      if (exists) {
        print("exists");
        final index = _locations.indexWhere((element) => element["city"]==c.city && element["street"]==street);
        _locations[index]['count']++;

      } else {
        _locations.add({"city":c.city,"street":street,"count":1});

      }
    }

    for(var m in _locations) {
      print(m);
    }

  }


  void myInit()async{
     contacts=await getContacts();
    makeSTbyMonth();
    makeSTbyYear();
   makeSTbyLocation();
    foundSTbyMonth();
    foundSTbyYear();
    setState(() {
      state=0;

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   myInit();


  }

  ///////////////////////////
  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,color:app_colors.languageButton,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text("עברית"),
          value: 1,
          onTap: (){print("change to hebrow");
          setState(() {
            my_texts.changeToHebrew();
         data.language=1;
          });


          },
        ),
        PopupMenuItem(
          child: const Text("English"),
          value: 1,
          onTap: (){
            print("change to english");
            setState(() {
              my_texts.changeToEnglish();
             data.language=0;
            });


          },
        ),
        PopupMenuItem(
          child: const Text("عربيه"),
          value: 1,
          onTap: (){
            print("change to english");
            setState(() {
              my_texts.changeToArabic();
              data.language=2;
            });


          },
        ),
      ]
  );
   Widget backButton()=>IconButton(
     icon: const Icon(Icons.arrow_back,color: Colors.green,size: 40),
     onPressed:(){
       Navigator.pop(context);

     } ,
   );
  Widget monthButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: () {

        setState(() {
          state=1;
        });

      },
      child:  Text(my_texts.perMonth,
        style: const TextStyle(color: Colors.black,fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.deepOrange,
        minimumSize:const Size(150.0, 50.0),

      ),
    ),
  );
  Widget yearButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          state=2;
        });



      },
      child:  Text(my_texts.perYear,
        style: const TextStyle(color: Colors.black,fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.lightBlue,
        minimumSize:const Size(150.0, 50.0),

      ),
    ),
  );
  Widget placeButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          state=3;
        });



      },
      child:  Text(my_texts.perLocation,
        style: const TextStyle(color: Colors.black,fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.lightGreenAccent,
        minimumSize:const Size(150.0, 50.0),

      ),
    ),
  );
  Widget allContactsButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          state=0;
        });



      },
      child:  Text(my_texts.allContacts,
        style: const TextStyle(color: Colors.black,fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.yellow,
        minimumSize:const Size(150.0, 50.0),

      ),
    ),
  );

  Widget optionButtonsColumns()=>Container(
    height: 400,
    width: 170,
   // color: Colors.white,
    child: Column(
      children: [
        monthButton(),
        const SizedBox(height: 10,),
        yearButton(),
        const SizedBox(height: 10,),
        placeButton(),
        const SizedBox(height: 10,),
        allContactsButton(),

      ],
    ),


  );
  Widget rahatLogo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/rahatLogo2.png'),
        height: 100,
        width:100,
      )

  );


   Widget mainStack()=>Stack(
     children: [
       Align(alignment: const Alignment(1,0),child: optionButtonsColumns(),),
     if(state==1) Align(alignment: const Alignment(-0.7,0),child: ByMonth(months: _months,),),
       if(state==2) Align(alignment: const Alignment(-0.7,0),child: ByYear(years: _years,),),
       if(state==3) Align(alignment: const Alignment(-0.7,0),child: ByLocation(locations:_locations,),),
       if(state==0) Align(alignment: const Alignment(-1,0),child: allContacts(contacts: contacts,),)
     ],
   );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: app_colors.app_bar_background,
        title:  rahatLogo(),
        centerTitle: true,
        actions: [backButton(),const SizedBox(width: 10,),languageButton()],
      ),
      body: Container(
        decoration: BoxDecoration(
            color: app_colors.background,
            borderRadius: BorderRadius.circular(10),
            boxShadow:[
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: Offset(8,5)

              ),
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: Offset(-8,-5)
              ),
            ]
        ),
        child:mainStack(),


      ),
    );
  }
}
