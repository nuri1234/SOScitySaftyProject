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


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool isLoading=true;
  final maskFormatter = MaskTextInputFormatter(mask: 'XX#-#######', filter: { "#": RegExp(r'[0-9]') ,"X": RegExp(r'[0,5]') });
  final TextEditingController _phone= TextEditingController();
  String codeDigits="+972";
  bool verefystat=true;
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
  /////////////////////////methods//////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async{
    await Future.delayed(Duration(milliseconds: 5000),(){});
  //  await data.initData();
    await data.getData();
    print(data.phon_verfyed);
    setState(() {
      isLoading=false;
      appbar=my_texts.phone_verification;
    });

  }
  void updateData() {

   setState(() {
     data.phone=maskFormatter.getUnmaskedText();
     data.phon_verfyed=true;
   });
   data.updateData();

  }
  /////////////////////////end methods//////////////////////////////////////////
////wegets////////////////////////////////////////////////////
  Widget logo()=>const Image(
    image: AssetImage('assets/images/logo.png'),
  height: 200,
    width: 200,

  );
  Widget Welcome()=> Text(
    my_texts.welcome,
    style: GoogleFonts.pacifico(fontSize: 60,fontWeight: FontWeight.w300,color: app_colors.Welcome),

  );
  Widget loading()=>Center(child: const CircularProgressIndicator(color: Colors.black, ));
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
        verefystat=true;
      });
    }
    }


);
  Widget my_stak()=>Stack(
  children: [
    Center(child: Column(children: [SizedBox(height:0,),Welcome()],)),
    Center(child: Column(children: [SizedBox(height: 40,),
      logo(),
      if(isLoading) loading()
      else
      if(verefystat)phone_verefy()
      else phone_verefy2(),
    ], ),),
]
  );


  /////////////////////////////////Containers/////////////////////////////////////////////////////////////////
  Widget phone_verefy2()=>  Container(
    margin: EdgeInsets.all(7.0),
    child: Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: (){},
            child: Text("verifying: ${codeDigits}--${ maskFormatter.getUnmaskedText()}",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),

            ),

          ),
          SizedBox(height: 10,),
          Center(child: pinPut()),

        ],
      ),

    ),

  );
  Widget phone_verefy()=>Container(
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
                  offset: Offset(1.0, 1.0),
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
              ElevatedButton(
                onPressed:(){
                  debugPrint(_phone.text);
                  debugPrint(maskFormatter.getUnmaskedText());
                  verifyPhoneNumber();
                  setState(() {verefystat=false;});
                } ,


                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  primary:  app_colors.button,
                  minimumSize: Size(50.0, 40.0),
                ),
                child: Text(my_texts.Next, style: TextStyle(color: app_colors.text_button,fontWeight:FontWeight.bold ),),
              ),
            ],
          ),
      ),

  );
/////////////////////////////////endContainers/////////////////////////////////////////////////////////////////
  //////////////////////Scafolds//////////////////////////////////////////////////////
  Widget homeScaffold()=>Scaffold(
      backgroundColor: app_colors.background,
      appBar: AppBar(
        backgroundColor: app_colors.app_bar_background,
        title: Text(appbar) ,),
      body:Center(
        child: SingleChildScrollView (
          reverse: true,
          padding:  const EdgeInsets.all(4.0),
          child: my_stak(),

        ),
      )



  );
  ////////////////////////end Scafolds/////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    if(isLoading) return homeScaffold();
    else{
      if(data.phon_verfyed==true)
        return Sos();
      else
        return homeScaffold();

  }
  }
}
