import 'package:client_side/texts.dart';
import 'package:flutter_test/flutter_test.dart';
////////////////////////////unit test

void main(){
  test('test change to English methode',(){
    my_texts.changeEnglish();
expect(my_texts.endContact,"end Contact");
  });

  test('test change to hebrew methode',(){
    my_texts.changeToHebrew();
    expect(my_texts.endContact,"סגור פנייה");
  });

  test('test change to arabic methode',(){
    my_texts.changeToArabic();
    expect(my_texts.endContact,"تطبيق وثيقة");
  });


}