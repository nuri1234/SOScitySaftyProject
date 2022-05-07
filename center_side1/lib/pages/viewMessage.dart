import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/dbHelper/mongodb.dart';
import 'package:center_side/dbHelper/contacts_model.dart';
import 'package:center_side/uses/share_data.dart';
import 'package:flutter/material.dart';


class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}


class _MessageListState extends State<MessageList> {

  List<Contact> _messages= [];

  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,size: 30,) ,
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
          child: const Text("العربية"),
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
                title: Text(my_texts.ThisMessage+_messages[index].date),
                leading: CircleAvatar(
                  backgroundImage:AssetImage('assets/images/green.jpg') ,
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
                              await MongoDB.deleteContact(_messages[index]);
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            }, child: Text(my_texts.OK)),
                            FlatButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text(my_texts.Cancel)),
                          ],
                          title: Text(my_texts.ConfiemDelete),
                          contentPadding: EdgeInsets.all(20),
                          content: Text(my_texts.DeleteMessage+_messages[index].description),
                          titleTextStyle: TextStyle(color: Colors.blue,fontSize: 25),
                          contentTextStyle: TextStyle(color: Colors.red,fontSize:15),
                        );
                      });
                    },
                    color:app_colors.app_bar_background,
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
        title:Text(my_texts.MessageList),
        backgroundColor: app_colors.app_bar_background,
        centerTitle: true,
        elevation: 6,
        actions: [
          languageButton(),
          IconButton(icon: Icon(Icons.home),onPressed: (){
            Navigator.of(context).popAndPushNamed('maneger');
          },),
          IconButton(icon: Icon(Icons.refresh),onPressed: (){
            Navigator.of(context).popAndPushNamed('messageList');
          },),
          IconButton(icon: Icon(Icons.exit_to_app),onPressed: (){
            Navigator.of(context).popAndPushNamed('homePage');
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
              height: 400,
              width: 600,
              decoration: BoxDecoration(
                color: app_colors.background,
                border: Border.all(color: Colors.black,width: 7),
                borderRadius: BorderRadius.circular(20)
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(  child:Row(
                    children: [
                      Text(my_texts.WorkerName+":",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize:20,decoration: TextDecoration.underline),),
                      Text(message.worker_userName),
                    ],
                  ) ,style: TextStyle(fontSize:20,color:Colors.black)),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                    children: [
                      Text(my_texts.CitizenName+":",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                      Text(message.client_userName),
                    ])
                    ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text(my_texts.Citizenphone+":",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.client_phone),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text(my_texts.CitizenAddress+":",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.street),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text(my_texts.ThisMessage,style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.date),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text(my_texts.description+":",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.description),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),
                  SizedBox(height: 15,),
                  DefaultTextStyle(  child:Row(
                      children: [
                        Text(my_texts.EventType+":",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        Text(message.event_type),
                      ])
                  ,style: TextStyle(fontSize: 20,color:Colors.black),),

              ],),
            ) ,
          ),
        );
      });
}