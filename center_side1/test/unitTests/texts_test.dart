import 'package:flutter_test/flutter_test.dart';
import 'package:center_side/compount/texts.dart';



void main(){

  test('test the init language',(){
    expect(my_texts.city,"city");
    expect(my_texts.street,"street");
    expect(my_texts.month,"month");
  });




  test('test change to hebrew methode',(){
    my_texts.changeToHebrew();
    expect(my_texts.city,"עיר");
    expect(my_texts.street,"רחוב");
    expect(my_texts.month,"חודש");
  });


  test('test change to English methode',(){
    my_texts.changeToEnglish();
    expect(my_texts.city,"city");
    expect(my_texts.street,"street");
    expect(my_texts.month,"month");
  });

  test('test change to arabic methode',(){
    my_texts.changeToArabic();
    expect(my_texts.city,"مدينة");
    expect(my_texts.street,"شارع");
    expect(my_texts.month,"شهر");
  });


}