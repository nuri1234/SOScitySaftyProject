import 'package:center_side/dbHelper/mongodb.dart';
import 'package:center_side/dbHelper/worker_model.dart';
import 'package:center_side/example2.dart';
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
    super.initState();
    loadWorkers();
  }


  Widget workerListView() => ListView.builder(
    itemCount:_workers.length,
    itemBuilder:(context,index){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
        child: Card(child:ListTile(
          onTap: (){},
          title: Text("שם העובד : "+_workers[index].fullName),
          leading: CircleAvatar(
            backgroundImage:AssetImage('assets/images/username2.png') ,
          ),
          trailing: Container(
            width: 100,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
            child: FlatButton(
              onPressed: (){},
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text("מחיקה",style: TextStyle(color:Colors.white),),
            ),
          ),
        )
        ),
      );
    }
    // children: <Widget>[
    //   for(WorkerModel worker in _workers)
    //    Text("username ${worker.userName}")
    //
    // ],


  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title:Text("רשימת עובדי המוקד"),
                backgroundColor: Colors.blue,
                centerTitle: true,
                elevation: 6,
              leading: IconButton(icon: Icon(Icons.person_add),onPressed: (){
                Navigator.of(context).popAndPushNamed('addUser');
              },),
              actions: [
                IconButton(icon: Icon(Icons.home),onPressed: (){
                  Navigator.of(context).popAndPushNamed('homePage');
                },),
                IconButton(icon: Icon(Icons.exit_to_app),onPressed: (){
                  examplePage2();
                },),
              ],
              ),
          body:workerListView(),
        )
    );
  }

}
