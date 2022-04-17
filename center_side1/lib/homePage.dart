import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/src/material/app.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState(){
    return HomeState();
  }
}

class HomeState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child:Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 6,
        actions: [
          IconButton(onPressed:(){}, icon: Icon(Icons.home)),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: Carousel(
              items:[
                AssetImage('assests/images/logo.pnp')
              ],
            ),
          )
        ],
      ),
    ));
  }

}
