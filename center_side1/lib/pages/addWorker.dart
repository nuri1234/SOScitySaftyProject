import 'package:center_side/compount/drawer.dart';
import 'package:flutter/material.dart';

class AddWorker extends StatefulWidget {
  const AddWorker({Key? key}) : super(key: key);

  @override
  State<AddWorker> createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text("הוספת עובד חדש"),
            backgroundColor: Colors.blue,
            centerTitle: true,
            elevation: 6,

          ),
          backgroundColor: Colors.white,
          drawer: MyDrawer(),
          body:SafeArea(child:ListView(children: [
        Text("",style: TextStyle(fontSize: 22),),

        Container(
          color: Colors.white,
          height: 100,
          width: 100,
          child:
            TextField:Text("hallo")
        ),
          ],),),),
    );
  }
}

