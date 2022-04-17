import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyDrawerState();
  }
}
class MyDrawerState extends State<MyDrawer>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
       child: ListView(
          children: [
            UserAccountsDrawerHeader
              (accountName:Text("name"),
                accountEmail:Text("email@gmail.com"),
                currentAccountPicture: CircleAvatar(child:Icon(Icons.person),),
                decoration: BoxDecoration(
                  color: Colors.blue,
                )
            ),
            ListTile(
              title:Text("דף הבית",style: TextStyle(color: Colors.black,fontSize: 15)),
              leading: Icon(Icons.home,color: Colors.black,size: 30),
              onTap: (){},
            ),
            Divider(color: Colors.blue,thickness: 1.0,),
            ListTile(
              title:Text("סטטיסטיקה",style: TextStyle(color: Colors.black,fontSize: 15)),
              leading: Icon(Icons.category,color: Colors.black,size: 30),
              onTap: (){},
            ),
            Divider(color: Colors.blue,thickness: 1.0,),
            ListTile(
              title:Text("עזרה",style: TextStyle(color: Colors.black,fontSize: 15)),
              leading: Icon(Icons.help,color: Colors.black,size: 30),
              onTap: (){},
            ),
            Divider(color: Colors.blue,thickness: 1.0,),
            ListTile(
              title:Text("שפה",style: TextStyle(color: Colors.black,fontSize: 15)),
              leading: Icon(Icons.language,color: Colors.black,size: 30,),
              onTap: (){},
            ),
            Divider(color: Colors.blue,thickness: 1.0,),
            ListTile(
              title:Text("התנתקות",style: TextStyle(color: Colors.black,fontSize: 15)),
              leading: Icon(Icons.logout,color: Colors.black,size: 30,),
              onTap: (){},
            ),
            Divider(color: Colors.blue,thickness: 1.0,),
          ],
        )
    );
  }
}