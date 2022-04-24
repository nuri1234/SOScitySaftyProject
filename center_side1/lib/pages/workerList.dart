import 'package:center_side/dbHelper/mongodb.dart';
import 'package:center_side/dbHelper/worker_model.dart';
import 'package:flutter/material.dart';


class WorkerList extends StatefulWidget {
  const WorkerList({Key? key}) : super(key: key);

  @override
  State<WorkerList> createState() => _WorkerListState();
}


class _WorkerListState extends State<WorkerList> {
  List<WorkerModel> _workers= [];

  void  loadWorkers()async{
    var workers=await MongoDB.getWorkers();
    for(var worker in workers){
      WorkerModel newWorker=WorkerModel(
          id:worker['_id'],
          fullName:worker['fullName'],
          userName:worker['userName'],
          password: worker['password']);
      setState(() {
        _workers.add(newWorker);
      });


    }
    print(workers);


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadWorkers();
  }


  Widget workerListView() => ListView(
    children: <Widget>[
      for(WorkerModel worker in _workers)
       Text("username ${worker.userName}")

    ],


  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child:Scaffold(
          body:workerListView()
        )
    );
  }

}
