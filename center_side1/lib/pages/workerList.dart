import 'package:center_side/compount/center_text.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/dbHelper/mongodb.dart';
import 'package:center_side/dbHelper/worker_model.dart';
import 'package:center_side/uses/share_data.dart';
import 'package:center_side/pages/homePage.dart';
import 'package:center_side/pages/maneger.dart';
import 'package:flutter/material.dart';
import 'package:center_side/compount/colors.dart';

class WorkerList extends StatefulWidget {
  const WorkerList({Key? key}) : super(key: key);

  @override
  State<WorkerList> createState() => _WorkerListState();
}


class _WorkerListState extends State<WorkerList> {

  List<WorkerModel> _workers= [];

  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,),
        //color:app_colors.languageButton,size: 40,) ,
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


  Widget workerListView() => RefreshIndicator(
      onRefresh: _refresh,
      backgroundColor: Colors.orange[100],
      child:ListView.builder(
          itemCount:_workers.length,
          itemBuilder:(context,index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Card(child:ListTile(
                onTap: (){},
                title: Text(my_texts.WorkerName+":"+_workers[index].fullName),
                leading: CircleAvatar(
                  backgroundImage:AssetImage('assets/images/username2.png') ,
                ),
                trailing: Container(
                  width: 100,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  child:
                  FlatButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: Colors.orange[200],
                          actions: [
                            FlatButton(onPressed: ()async{
                              await MongoDB.deleteWorker(_workers[index]);
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            }, child: Text(my_texts.OK,style: TextStyle(fontWeight:FontWeight.bold),)),
                            FlatButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text(my_texts.Cancel,style: TextStyle(fontWeight:FontWeight.bold),)),
                          ],
                          title: Text(my_texts.ConfiemDelete,style: TextStyle(fontWeight:FontWeight.bold),),
                          contentPadding: EdgeInsets.all(20),
                          content: Text(my_texts.DeleteMessage+_workers[index].fullName),
                          titleTextStyle: TextStyle(color: Colors.black,fontSize: 25),
                          contentTextStyle: TextStyle(color: Colors.black,fontSize:15),
                        );
                      });
                    },
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(my_texts.Delete,style: TextStyle(color:Colors.white),),
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


      )
  );
  Future _refresh(){
    return Future.delayed(Duration(seconds:0));
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            title:Text(my_texts.WorkersList),
            backgroundColor: Colors.orange,
            centerTitle: true,
            elevation: 6,
            leading: IconButton(icon: Icon(Icons.person_add),onPressed: (){
              Navigator.of(context).popAndPushNamed('addUser');
            },),
            actions: [
              languageButton(),
              IconButton(icon: Icon(Icons.home),onPressed: (){
                Navigator.of(context).popAndPushNamed('maneger');
              },),
              IconButton(icon: Icon(Icons.refresh),onPressed: (){
                Navigator.of(context).popAndPushNamed('workerList');
              },),
              IconButton(icon: Icon(Icons.exit_to_app),onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>(HomePage())),);
                },),
            ],
          ),
          body:workerListView(),
        )
    );
  }

}