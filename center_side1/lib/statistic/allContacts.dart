import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/uses/share_data.dart';
import 'package:center_side/dbHelper/contacts_model.dart';



class allContacts extends StatelessWidget {
  List<Contact> contacts;


  allContacts({Key? key,required this.contacts}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TextStyle columnText()=>const TextStyle(fontStyle: FontStyle.italic,fontSize: 17);
    TextStyle RowText()=>const TextStyle(fontStyle: FontStyle.italic,fontSize: 15);

    Widget allContactsText()=> Text(
      my_texts.allContacts,
      style:const TextStyle(
        fontSize:20,
        color:Colors.black,
        fontWeight: FontWeight.w800,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(0, 0),
            blurRadius: 3.0,
            color: Color.fromARGB(500, 7, 0, 0),
          ),
          Shadow(
            offset: Offset(0.0, 10.0),
            blurRadius: 8.0,
            color: Color.fromARGB(125, 0, 0, 255),
          ),
        ],
      ),

    );
    DataColumn dataDataColumnBox(String name,double width)=>DataColumn(
      label: Container(
     //   color: Colors.red,
        width:width,
        child: Text(
          name,
          style: columnText(),

        ),


      ),
    );
    DataCell dataCellRowBox(String name,double width)=>DataCell(
      
    Container(
        width:width,

   //   color: Colors.blue,

        child: Text(
          name,
          style: RowText(),

        ),


      ),
    );

    Widget table()=>DataTable(
      horizontalMargin: 0,
      columnSpacing: 10,
      dataRowHeight: 100,
      columns:
      <DataColumn>[
        dataDataColumnBox(my_texts.workerUserName,80),
        dataDataColumnBox(my_texts.userName,80),
        dataDataColumnBox(my_texts.phone,90),
        dataDataColumnBox(my_texts.city,80),
        dataDataColumnBox(my_texts.street,80),
        dataDataColumnBox(my_texts.date,80),
        dataDataColumnBox(my_texts.time,70),
        dataDataColumnBox(my_texts.topic,70),
        dataDataColumnBox(my_texts.description,100),

    ],
      rows:  <DataRow>[
        for(Contact c in contacts) DataRow(
          cells: <DataCell>[
            dataCellRowBox(c.worker_userName,80),
            dataCellRowBox(c.client_userName,80),
            dataCellRowBox(c.client_phone,90),
            dataCellRowBox(c.city,80),
            dataCellRowBox(c.street,80),
            dataCellRowBox(c.date.substring(0,10),80),
            dataCellRowBox(c.hour,70),
            dataCellRowBox(c.event_type,70),
            dataCellRowBox(c.description,100),


          ],
        ),

      ],);

    Widget  tableView() => ListView(
      children: <Widget>[
        table(),


      ],
    );

    Widget tableContainer()=>SingleChildScrollView(
      child: Container(
        height: 500,

      //  color: Colors.pink,
        alignment: Alignment.topCenter,
        child: tableView(),

      ),
    );
    Widget mainStack()=>Stack(
      children: [
        Align(alignment: const Alignment(0,-1),child:allContactsText(),),
        Align(alignment: const Alignment(0,0),child:tableContainer(),),

      ],
    );




    return Container(
      height: 600,
      width: 860,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
          color: app_colors.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(8, 5)

            ),
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(-8, -5)
            ),
          ]
      ),
      child: mainStack(),
    );
  }
}
