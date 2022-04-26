import 'package:center_side/compount/colors.dart';
import 'package:center_side/dbHelper/mongodb.dart';
import 'package:center_side/dbHelper/contacts_model.dart';
import 'package:center_side/example2.dart';
import 'package:flutter/material.dart';


class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}


class _MessageListState extends State<MessageList> {

  List<Contact> _messages= [];

  void  loadMessages()async{
    var messages=await MongoDB.getContacts();
    for(var message in messages){
      Contact newMessage=Contact(
          id:message['_id'],
          worker_userName:message['worker_userName'],
          date:message['date'],
          client_userName: message['client_userName'],
          client_phone:message['client_phone'],
          city:message['city'],
          street:message['street'],
          event_type: message['event_type'],
          description: message['description'],
      );
      setState(() {
        _messages.add(newMessage);
      });
    }
    print(messages);
  }

  @override
  void initState() {
    super.initState();
    loadMessages();
  }


  Widget workerListView() => RefreshIndicator(
      onRefresh: _refresh,
      child:ListView.builder(
          itemCount:_messages.length,
          itemBuilder:(context,index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Card(child:ListTile(
                onTap: (){
                  showDialogFunc(context,_messages[index]);
                },
                subtitle: Text(_messages[index].description),
                title: Text("This messege was received on :"+_messages[index].date),
                leading: CircleAvatar(
                  backgroundImage:AssetImage('assets/images/green.png') ,
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
                          actions: [
                            FlatButton(onPressed: ()async{
                              await MongoDB.deleteContact(_messages[index]);
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            }, child: Text("OK")),
                            FlatButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text("Cancel")),
                          ],
                          title: Text("Confirm Delete"),
                          contentPadding: EdgeInsets.all(20),
                          content: Text("Are you sure to delete: "+_messages[index].description),
                          titleTextStyle: TextStyle(color: Colors.blue,fontSize: 25),
                          contentTextStyle: TextStyle(color: Colors.red,fontSize:15),
                        );
                      });
                    },
                    color:app_colors.app_bar_background,
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
      )
  );
  Future _refresh(){
    return Future.delayed(Duration(seconds:0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.background,
      appBar: AppBar(
        title:Text("רשימת ההתראות"),
        backgroundColor: app_colors.app_bar_background,
        centerTitle: true,
        elevation: 6,
        actions: [
          IconButton(icon: Icon(Icons.home),onPressed: (){
            Navigator.of(context).popAndPushNamed('homePage');
          },),
          IconButton(icon: Icon(Icons.refresh),onPressed: (){
            Navigator.of(context).popAndPushNamed('messageList');
          },),
          IconButton(icon: Icon(Icons.exit_to_app),onPressed: (){
            examplePage2();
          },),
        ],
      ),
      body:workerListView(),
    );
  }

}
showDialogFunc(context,Contact message){
  return showDialog(
      context: context,
      builder: (context){
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child:Container(
              padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              height: 350,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                border: Border.all(color: Colors.black,width: 7),
                borderRadius: BorderRadius.circular(20)
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(  child:Row(
                    children: [
                      Text("Worker's Name :",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize:20,decoration: TextDecoration.underline),),
                      Text(message.worker_userName),
                    ],
                  ) ,style: TextStyle(fontSize:20,color:Colors.black)),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                    children: [
                      Text("Citizen's Name :",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                      Text(message.client_userName),
                    ])
                    ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text("Citizen's Phone Number :",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.client_phone),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text("Citizen's Address :",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.street),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text("The messege was received on :",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.date),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text("The Description :",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.description),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text("The messege was received on :",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.event_type),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),

              ],),
            ) ,
          ),
        );
      });
}