import 'package:center_side/dbHelper/mongodb.dart';
import 'package:center_side/dbHelper/worker_model.dart';
import 'package:flutter/material.dart';


class WorkerList extends StatefulWidget {
  const WorkerList({Key? key}) : super(key: key);

  @override
  State<WorkerList> createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {
  late WorkerModel worker;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child:Scaffold(
          body: SafeArea(child: FutureBuilder(
            future: MongoDB.getWorkers(),
            builder: (context,AsyncSnapshot snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              if(snapshot.hasData){
                var workerList=MongoDB.getWorkers();
                print("Total Data ");
                return ListView(children: [
                ],

                );
              }
            else{
              return Center(child: Text("No Data Available."),);
            }}
          },),
        ),
        )
    );
  }
}
