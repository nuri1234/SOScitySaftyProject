import 'package:client_side/texts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:client_side/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:client_side/local_data.dart';



void main(){
  group('test app',(){

    testWidgets("input phone Button test", (tester) async {

      await Future.delayed(const Duration(seconds:3));
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      await app.main();
      await  tester.pumpAndSettle();
      final inputPhoneButton=await find.byKey(Key('inputPhoneButton'));
      expect(inputPhoneButton,findsOneWidget);
      await tester.tap(inputPhoneButton);
      await Future.delayed(const Duration(seconds:7));
      final backButton=await find.byKey(Key('backButton'));
      expect(backButton,findsOneWidget);
      await tester.pumpAndSettle();
    });


    testWidgets("continue button test", (tester) async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      data.first_time=true;
      await data.updateData();
      await app.main();
      await  tester.pumpAndSettle();
      final continueButton=await find.byKey(Key('continueButton'));
      expect(continueButton,findsOneWidget);
      await tester.tap(continueButton);
      await Future.delayed(const Duration(seconds:7));
      await tester.pumpAndSettle();
      expect(find.text("SOS"),findsOneWidget);
    });

    testWidgets("change username test", (tester) async {
      data.first_time=true;
      await data.updateData();
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      await app.main();
      await  tester.pumpAndSettle();
      final userNameTextField=await find.byKey(Key('userNameTextField'));
      final saveButton=await find.byKey(Key('saveButton'));
      expect(userNameTextField,findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(userNameTextField);  // acquire focus
      await tester.enterText(userNameTextField,"nuri");
      await Future.delayed(const Duration(seconds:3));
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      print(data.user_name);
      expect(data.user_name,"nuri");

    });

    testWidgets("change language button test", (tester) async {
      data.first_time=true;
      await data.updateData();
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      await app.main();
      await Future.delayed(const Duration(seconds:5));
      await  tester.pumpAndSettle();
      expect(my_texts.username,"username");
      final languageButton=await find.byKey(Key('languageButton'));
      expect(languageButton,findsOneWidget);


      await tester.tap(languageButton);  // acquire focus
      await Future.delayed(const Duration(seconds:3));
      await  tester.pumpAndSettle();

      final arabicButton=await find.byKey(Key('arabic'));
      final hebrewButton=await find.byKey(Key('hebrew'));
      final englishButton=await find.byKey(Key('english'));

      expect(arabicButton,findsOneWidget);
      expect(hebrewButton,findsOneWidget);
      expect(englishButton,findsOneWidget);

      await tester.tap(arabicButton);
      await Future.delayed(const Duration(seconds:5));
      await tester.pumpAndSettle();
      expect(my_texts.username,"اسم المستخدم");

      await tester.tap(languageButton);  // acquire focus
      await Future.delayed(const Duration(seconds:3));
      await  tester.pumpAndSettle();


      await tester.tap(hebrewButton);
      await Future.delayed(const Duration(seconds:5));
      await tester.pumpAndSettle();
      expect(my_texts.username,"שם משתמש");

      await tester.tap(languageButton);  // acquire focus
      await Future.delayed(const Duration(seconds:3));
      await  tester.pumpAndSettle();


      await tester.tap(englishButton);
      await Future.delayed(const Duration(seconds:5));
      await tester.pumpAndSettle();
      expect(my_texts.username,"username");




    });



  });//end group






}