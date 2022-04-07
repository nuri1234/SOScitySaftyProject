import 'package:client_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'local_data.dart';
import 'sos_screen.dart';
import 'registration_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading=true;

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
    child: Text(my_texts.welcome),

  );
  Widget WelcomeContainer()=>Container(
    // color: Colors.red,
      height: 250,
      width:400,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,1),child: logo(),),

      ],)

  );


  void loadData() async{
    //  await data.initData();
    await data.getData();
    print("is first time?");
    print(data.first_time);
  if(data.first_time){
    data.first_time=false;
    data.updateData();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>(Registor())),);}
  else Navigator.push(context, MaterialPageRoute(builder: (context)=>(Sos())),);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: app_colors.background,
      child: Center(
        child: Column(children: [
          const SizedBox(height: 100,),
          WelcomeContainer(),
          loading(),

        ],),
      ),

    );
  }
}
