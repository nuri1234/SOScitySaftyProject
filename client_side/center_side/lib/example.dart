import 'package:center_side/nuri/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nuri/texts.dart';


class examplePage extends StatefulWidget {
  const examplePage({Key? key}) : super(key: key);

  @override
  State<examplePage> createState() => _examplePageState();
}

class _examplePageState extends State<examplePage> {

  Widget loading()=>const Center(child: CircularProgressIndicator(color: Colors.black, ));
  Widget logo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/logo.png'),
        height: 200,
        width: 200,
      )

  );
  Widget welcome()=> DefaultTextStyle(
    style: GoogleFonts.pacifico(fontSize: 60,fontWeight: FontWeight.w300,color: app_colors.Welcome),
    child: Text(my_texts.welcome),);


  Widget WelcomeContainer()=>Container(
    // color: Colors.green,
      height: 250,
      width:400,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,1),child: logo(),),

      ],)

  );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: app_colors.background,
        appBar: AppBar(
        backgroundColor: app_colors.app_bar_background,
        title: Text("hello") ,),
    body:  Center(child: WelcomeContainer())
    );

  }
}
