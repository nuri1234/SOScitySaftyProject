import 'package:audioplayers/audioplayers.dart';
import 'package:client_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'local_data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sos_main_screen.dart';


class Registor extends StatefulWidget {
  const Registor({Key? key}) : super(key: key);

  @override
  State<Registor> createState() => _RegistorState();
}


/////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////

class _RegistorState extends State<Registor> {
  final TextEditingController _user_name= TextEditingController();
  bool _save=false;
  bool _phoneInput=false;
  bool isLoading=true;
  final maskFormatter = MaskTextInputFormatter(mask: 'XX#-#######', filter: { "#": RegExp(r'[0-9]') ,"X": RegExp(r'[0,5]') });
  final TextEditingController _phone= TextEditingController();
  String codeDigits="+972";
  int state=0;
  String? varificationCode;
  TextEditingController otpCode = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static AudioCache player = AudioCache(prefix:'assets/sounds/');

  //////////////////////////////////////////////////verefing phonefunctions/////////
  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.otpCode.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try{
        UserCredential credential =
        await user!.linkWithCredential(authCredential);
      }on FirebaseAuthException catch(e){
        if(e.code == 'provider-already-linked'){
          await _auth.signInWithCredential(authCredential);
        }
      }


    }
  }
  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      print("The phone number entered is invalid!");
    }
  }
  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.varificationCode = verificationId;
    print(varificationCode);
    print(forceResendingToken);
    print("code sent");
  }
  _onCodeTimeout(String timeout) {
    return null;
  }
  verifyPhoneNumber() async{
    print("herejjjjjjjj");
    String phone= codeDigits+maskFormatter.getUnmaskedText();
    print(phone);

    await _auth.verifyPhoneNumber(
        phoneNumber:phone,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
    print("here3");
  }
  //////////////////////////end verefing phonefunctions/////////

  /////////////////////////////////////////////////////////////////
  Widget nextButton()=>ElevatedButton(
    onPressed:(){
      player.play('button.mp3');
      debugPrint(_phone.text);
      debugPrint(maskFormatter.getUnmaskedText());
      verifyPhoneNumber();
      setState(() {
        state=1;
      });

    } ,

    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90.0)
      ),
      primary:  app_colors.button,
      minimumSize: Size(50.0, 50.0),
    ),
    child: Text(my_texts.Next, style: TextStyle(color: app_colors.text_button,fontWeight:FontWeight.bold ,fontSize: 18),),
  );
  Widget nextButton2()=>ElevatedButton(
    onPressed:(){
      player.play('button.mp3');
      data.user_name=_user_name.text;
      updateData();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SOS()),);
    } ,

    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90.0)
      ),
      primary:  app_colors.button,
      minimumSize: Size(50.0, 50.0),
    ),
    child: Text(my_texts.Next, style: TextStyle(color: app_colors.text_button,fontWeight:FontWeight.bold ,fontSize: 18),),
  );
  Widget tryAgainButton()=>ElevatedButton(

    onPressed:(){
      player.play('button.mp3');
      debugPrint(_phone.text);
      debugPrint(maskFormatter.getUnmaskedText());
      // verifyPhoneNumber();
      setState(() {
        state=0;
      });

    } ,

    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90.0)
      ),
      primary:  app_colors.button,
      minimumSize: const Size(50.0, 50.0),
    ),
    child: Text(my_texts.try_again, style: TextStyle(color: app_colors.text_button,fontWeight:FontWeight.bold ,fontSize: 18),),
  );
  Widget pinPut()=>PinCodeTextField(
      appContext: context,
      length: 6,
      onChanged: (value){print(value);},
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(0),
        fieldHeight: 50,
        fieldWidth: 50,
        inactiveColor: Colors.black,
        activeColor: Colors.blue,
        selectedColor: Colors.white,

      ),
      onCompleted: (value)async{
        try{
          await FirebaseAuth.instance.signInWithCredential(
              PhoneAuthProvider.credential(
                  verificationId: varificationCode!, smsCode: value)).then((value) {
            if(value.user!=null){
              print("worked");
              updateData();
              _phoneInput=false;


            }
          });

        }
        catch(e){
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("invaild OTP"),
                duration: Duration(seconds: 5),
                backgroundColor: Colors.red,

              )
          );
          setState(() {
            state=3;
          });
        }
      }



  );
  Widget verifyingTextContainer()=>Container(
    height: 50,
    width: 400,
    //color: Colors.yellow,
    child: Text("verifying: ${codeDigits}--${ maskFormatter.getUnmaskedText()}",
      style:GoogleFonts.abel(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),

    ),
  );
  Widget phoneVerificationContainer()=>Container(
    padding: EdgeInsets.all(20),
    //  color: Colors.blue,
    height: 250,
    width:400,
    child: Center(
      child: Column(
        children: [
          Text(my_texts.EnterPhon,
            style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black),),
          SizedBox(height: 10,),
          TextField(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0) ,

                ),
                prefixIcon: Icon(Icons.add_ic_call_outlined,color:app_colors.BorderSide,size: 20.0,),
                hintText:my_texts.phoneNumber,
                fillColor: app_colors.textInputFill,
                filled: true,
                prefix: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text("+972"),
                ) ),
            maxLength: 11,

            keyboardType: TextInputType.number,
            controller: _phone,
            inputFormatters: [maskFormatter],
          ),
          nextButton(),
        ],
      ),
    ),


  );
  Widget phoneVerificationContainer2()=>Container(
    padding: EdgeInsets.all(20),
    //    color: Colors.pinkAccent,
    height: 250,
    width:400,
    child: Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: (){},
            child:verifyingTextContainer(),

          ),

          const SizedBox(height: 20,),
          Center(child: pinPut()),
          const SizedBox(height: 20,),
          tryAgainButton(),

        ],
      ),
    ),
  );
  Widget phoneVerificationMainContainer()=>Container(
    color: Colors.green,

  );
  ////////////////////////////////////////


  @override
  void initState(){
    super.initState();
    data.getData();
    setState(() {
      _user_name.text=data.user_name;
    });

  }
  void save(){
    player.play('button.mp3');
    setState(() {
      _save=false;
    });
    print("save");

    data.user_name=_user_name.text;
    data.updateData();

  }
  void updateData() {

    setState(() {
      data.phone=maskFormatter.getUnmaskedText();
      data.phone_verified=true;
      state=3;
    });
    data.updateData();

  }

///////////////////////////////
  Widget logo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/logo.png'),
        height: 150,
        width: 150,
      )

  );
  Widget welcome()=> DefaultTextStyle(
    style: GoogleFonts.pacifico(fontSize: 50,fontWeight: FontWeight.w300,color: app_colors.Welcome),
    child: Text(my_texts.welcome),

  );
  Widget welcomeContainer()=>Container(
    // color: Colors.red,
      height: 200,
      width:350,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,1),child: logo(),),

      ],)

  );
  Widget saveButton()=>IconButton(
    onPressed: save,
    icon:Icon(Icons.save,size: 50,color: _save? Colors.green: Colors.grey,) ,

  );
  Widget clear_phone()=>IconButton(
    onPressed: (){
      player.play('button.mp3');
      setState(() {
        data.phone="non";
        data.phone_verified=false;
        _phoneInput=true;
      });
      data.updateData();
    },
    icon:const Icon(Icons.clear,size: 20,color:Colors.red,) ,

  );
  Widget inputPhone_Button()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        player.play('button.mp3');
        setState(() {
          _phoneInput=true;
        });
      },
      child:Text(my_texts.inputPhone,style:TextStyle(color: app_colors.text_button,fontWeight:FontWeight.bold ,fontSize: 18)),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:app_colors.button,
        minimumSize: Size(70.0, 70.0),

      ),
    ),
  );
////////////////////////////////////////////////////
  Widget inputuserNameTextField()=>Container(
    height:110,
    width:300,
    padding: EdgeInsets.all(20),
    child: TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color:app_colors.BorderSide, width: 0.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
          borderRadius: BorderRadius.circular(20.0) ,

        ),
          prefixIcon:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${my_texts.username} : ",style: GoogleFonts.aBeeZee(fontSize:20,fontWeight: FontWeight.bold,color: Colors.black),),
          ),
          fillColor: app_colors.textInputFill,

          filled: true,
          ),
      maxLines: 15,
      controller: _user_name,
      style:  GoogleFonts.aBeeZee(fontSize:20,fontWeight: FontWeight.bold,color: Colors.lightGreenAccent),
      textAlign: TextAlign.left,
      onChanged: (_user_name){setState(() {
        _save=true;
      });},
    ),
  );


  Widget deatailsContainer()=>Container(
    // color: Colors.red,
    height: 110,
    width:350,
   // color: Colors.pink,
    child: Stack(
        children: [
          Align(alignment: const Alignment(-1,-1),child:inputuserNameTextField(),),
          Align(alignment: const Alignment(0.9,-0.4),child:saveButton(),),


        ],

    ),
  );




  Widget mainColumn()=>SingleChildScrollView(
    reverse: true,
    child: Column(
        children: [
          Container(
              height: 100,
              width: 300,
             // color: Colors.grey,
              child: Center(child: my_texts.explaneText)),
          deatailsContainer(),
         if(data.phone_verified) Center(
           child: Row(
             children: [
               Text(" ${my_texts.phoneNumber}: ${data.phone}",style: TextStyle(fontSize: 20),),
               clear_phone()
             ],
           ),
         ),
         if(!_phoneInput) inputPhone_Button(),
          if(_phoneInput) if(state==0)
            phoneVerificationContainer(),
          if(state==1)
            phoneVerificationContainer2(),

        ]),
  );
  Widget mainStack()=>Stack(
    children: [
      Align(alignment: const Alignment(0,0.2),child:mainColumn(),),
      Align(alignment: const Alignment(0,-0.7),child:welcomeContainer()),
      Align(alignment: const Alignment(1,-0.9),child:IconButton(
        icon: Icon(Icons.next_plan,color:Colors.lightGreenAccent,size: 40,),
        onPressed: (){
          player.play('button.mp3');
          Navigator.push(context, MaterialPageRoute(builder: (context)=>(SOS())),);

        },
      )),

    ],

  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.background,
      body:mainStack(),
    );
  }
}
