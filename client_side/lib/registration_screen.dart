
import 'package:client_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'local_data.dart';
import 'sos_screen.dart';
import 'package:client_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'local_data.dart';
import 'sos_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  bool isLoading=true;
  final maskFormatter = MaskTextInputFormatter(mask: 'XX#-#######', filter: { "#": RegExp(r'[0-9]') ,"X": RegExp(r'[0,5]') });
  final TextEditingController _phone= TextEditingController();
  final TextEditingController _user_name= TextEditingController();
  String codeDigits="+972";
  int state=0;
  String? varificationCode;
  TextEditingController otpCode = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String appbar=my_texts.home_page;
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
  /////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
  }

  void updateData() {

    setState(() {
      data.phone=maskFormatter.getUnmaskedText();
      data.phon_verfyed=true;
      state=3;
    });
    data.updateData();

  }
  ////////////////////////////////////////////////////////




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
  Widget welcomeContainer()=>Container(
   // color: Colors.red,
      height: 250,
      width:400,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,1),child: logo(),),

      ],)

  );

  Widget nextButton()=>ElevatedButton(
    onPressed:(){
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
      data.user_name=_user_name.text;
      updateData();
     Navigator.push(context, MaterialPageRoute(builder: (context)=>Sos()),);
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
  Widget inputNameTex()=>DefaultTextStyle(
    style: GoogleFonts.pacifico(fontSize: 28,fontWeight: FontWeight.w300,color: app_colors.Welcome),
    child: Text(my_texts.enter_name),);


  Widget inputNameTextField()=>TextField(
  decoration: InputDecoration(
  enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
  borderRadius: BorderRadius.circular(20.0),
  ),
  focusedBorder:OutlineInputBorder(
  borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
  borderRadius: BorderRadius.circular(20.0) ,

  ),
  prefixIcon: Icon(Icons.supervised_user_circle,color:app_colors.BorderSide,size: 20.0,),
  fillColor: app_colors.textInputFill,
  filled: true,
  prefix: Padding(
  padding: EdgeInsets.all(4),
  ) ),
  maxLength: 11,

  keyboardType: TextInputType.name,
  controller: _user_name,
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
            style: GoogleFonts.stylish(
              fontSize:28,
              color: app_colors.explaneText,
              fontWeight: FontWeight.w100,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: app_colors.buttom_shadow,
                  offset: const Offset(1.0, 1.0),
                ),

              ],

            ),

          ),
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
  Widget inputName()=>Container(
    padding:const EdgeInsets.all(20),
    //color: Colors.deepOrangeAccent,
    height: 250,
    width:400,
    child: Column(children: [
      inputNameTex(),
      inputNameTextField(),
      nextButton2(),
    ],),

  );

  Widget mainStack()=>Stack(
   children: [
      welcomeContainer(),
  SingleChildScrollView( child:Column(
  children: [
  const SizedBox(height: 210,),
  if(state==0)
  phoneVerificationContainer(),
  if(state==1)
  phoneVerificationContainer2(),
  if(state==3) inputName(),
  ],
  ),),


    ],

  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: app_colors.background,
        appBar: AppBar(
        backgroundColor: app_colors.app_bar_background,
          title: Text(my_texts.registration) ,),
      body: SingleChildScrollView(
        reverse: true,
        padding:  const EdgeInsets.all(5.0),
        child: mainStack(),
      ),
      //mainContainer(),



    );
  }
}
