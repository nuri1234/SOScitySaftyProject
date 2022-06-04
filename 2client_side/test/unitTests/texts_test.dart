import 'package:client_side/texts.dart';
import 'package:flutter_test/flutter_test.dart';
////////////////////////////unit test

void main(){

  test('test the init language',(){
    expect(my_texts.endContact,"end Contact");
    expect(my_texts.Next,"Next");
    expect(my_texts.phoneNumber,"phone number");
  });




  test('test change to hebrew methode',(){
    my_texts.changeToHebrew();
    expect(my_texts.endContact,"סגור פנייה");
    expect(my_texts.Next,"הבא");
    expect(my_texts.phoneNumber,"מספר טלפון");
  });


  test('test change to English methode',(){
    my_texts.changeEnglish();
    expect(my_texts.endContact,"end Contact");
    expect(my_texts.Next,"Next");
    expect(my_texts.phoneNumber,"phone number");
  });

  test('test change to arabic methode',(){
    my_texts.changeToArabic();
    expect(my_texts.endContact,"تطبيق وثيقة");
    expect(my_texts.Next,"التالي");
    expect(my_texts.phoneNumber,"رقم الهاتف");
  });


}