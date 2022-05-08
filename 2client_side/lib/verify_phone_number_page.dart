
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


class verifyPhone extends StatefulWidget {


  const verifyPhone({Key? key}) : super(key: key);

  @override
  State<verifyPhone> createState() => _verifyPhoneState();
}


/////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////

class _verifyPhoneState extends State<verifyPhone> {
  bool isLoading=true;
  final maskFormatter = MaskTextInputFormatter(mask: 'XX#-#######', filter: { "#": RegExp(r'[0-9]') ,"X": RegExp(r'[0,5]') });
  final TextEditingController _phone= TextEditingController();
  String codeDigits="+972";
  int state=0;
  String? varificationCode;
  TextEditingController otpCode = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool showResult=false;
  bool verifed=false;

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
          await auth.signInWithCredential(authCredential);
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

    String phone= codeDigits+maskFormatter.getUnmaskedText();
    data.phone=phone;
    print(phone);

    await auth.verifyPhoneNumber(
        phoneNumber:phone,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);

  }
  //////////////////////////end verefing phonefunctions/////////
  /////////////////////////////////////////////////////////////////
  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,color:app_colors.languageButton,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text("العربية"),
          value: 1,
          onTap: (){print("change to arbic");
          setState(() {
            my_texts.changeToArabic();
          });
          data.language=1;
          data.updateData();
          },
        ),
        PopupMenuItem(
          child: const Text("English"),
          value: 1,
          onTap: (){
            print("change to english");
            setState(() {
              my_texts.changeEnglish();
            });
            data.language=0;
            data.updateData();

          },
        ),
        PopupMenuItem(
          child: const Text("עברית"),
          value: 1,
          onTap: (){
            print("change to עברית");
            setState(() {
              my_texts.changeToHebrew();
            });
            data.language=2;
            data.updateData();

          },
        ),
      ]
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
  Widget backButton()=>ElevatedButton(
    onPressed:(){
      Navigator.pop(context);

    } ,

    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90.0)
      ),
      primary:  app_colors.button,
      minimumSize: Size(50.0, 50.0),
    ),
    child: const Icon(Icons.arrow_back_outlined,color: Colors.black,),
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
              verifySucceed();
            }
            else {
              notSucceed();
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

  ////////////////////////////////////////
 void verifySucceed() async{
   print("verifySucceed()");
   data.phone_verified=true;
   updateData();
   setState(() {
     showResult=true;
     verifed=true;
   });


   await Future.delayed(const Duration(seconds: 2));
   Navigator.pop(context);





  }

  void notSucceed() async{
   print("NotSucceed()");


    setState(() {
      showResult=true;
      verifed=false;
    });
   await Future.delayed(const Duration(seconds: 2));
   setState(() {
     showResult=false;
     state=0;
   });

  }

  @override
  void initState(){
    super.initState();

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
        height: 200,
        width: 200,
      )

  );
  Widget ok()=> Text(
    my_texts.phone_verification_complete,
    style:const TextStyle(
      fontSize:20,
      color:Colors.green,
      fontWeight: FontWeight.w800,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, 0),
          blurRadius: 3.0,
          color: Color.fromARGB(500, 7, 0, 0),
        ),
        Shadow(
          offset: Offset(0.0, 10.0),
          blurRadius: 8.0,
          color: Color.fromARGB(125, 0, 0, 255),
        ),
      ],
    ),

  );
  Widget notOk()=> Text(
    my_texts.phone_verification_not_complete,
    style:const TextStyle(
      fontSize:20,
      color:Colors.red,
      fontWeight: FontWeight.w800,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, 0),
          blurRadius: 3.0,
          color: Color.fromARGB(500, 7, 0, 0),
        ),
        Shadow(
          offset: Offset(0.0, 10.0),
          blurRadius: 8.0,
          color: Color.fromARGB(125, 0, 0, 255),
        ),
      ],
    ),

  );
  Widget ShoweResult()=>Container(
   // color: Colors.grey,
    height: 200,
    width: 350,
    child: Stack(children: [
    if(verifed) Align(alignment: Alignment.center,child: ok(),)
      else Align(alignment: Alignment.center,child: notOk(),)


    ],),

      );
  Widget verifyContainer()=>Container(
    child: (state==0)? phoneVerificationContainer():phoneVerificationContainer2(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.background,
      body:SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
              children: [
                const SizedBox(height: 50,),
                logo(),
               if(showResult) ShoweResult()
                else verifyContainer(),
                backButton(),

          ]
    ),
        ),));
  }
}
