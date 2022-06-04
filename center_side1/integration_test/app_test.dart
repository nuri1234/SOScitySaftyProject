import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:center_side/main.dart' as app;
import 'package:flutter/material.dart';

void main(){
  group('test app',(){

    testWidgets("login with non existing user", (tester) async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      await app.main();
      await Future.delayed(const Duration(seconds:2));
      await  tester.pumpAndSettle();
      final loginButton=await find.byKey(Key('login'));
      expect(loginButton,findsOneWidget);
      tester.tap(loginButton);
      await Future.delayed(const Duration(seconds:3));
      await  tester.pumpAndSettle();


      final userNameTextField=await find.byKey(Key('userName'));
      final passTextField=await find.byKey(Key('pass'));
      expect(userNameTextField,findsOneWidget);
      expect(passTextField,findsOneWidget);

      await tester.tap(userNameTextField);  // acquire focus
      await tester.enterText(userNameTextField,"oo");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.tap(passTextField);  // acquire focus
      await tester.enterText(passTextField,"oo");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      await Future.delayed(const Duration(seconds:10));
      await  tester.pumpAndSettle();

      final NextButton=await find.byKey(Key('next'));
      expect(NextButton,findsOneWidget);
      await tester.tap(NextButton);

      await Future.delayed(const Duration(seconds:10));
      await  tester.pumpAndSettle();


      final text=await find.byKey(Key('userNotFond'));
      expect(text,findsOneWidget);





    });


    testWidgets("login with wrong password", (tester) async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      await app.main();
      await Future.delayed(const Duration(seconds:2));
      await  tester.pumpAndSettle();
      final loginButton=await find.byKey(Key('login'));
      expect(loginButton,findsOneWidget);
      tester.tap(loginButton);
      await Future.delayed(const Duration(seconds:3));
      await  tester.pumpAndSettle();


      final userNameTextField=await find.byKey(Key('userName'));
      final passTextField=await find.byKey(Key('pass'));
      expect(userNameTextField,findsOneWidget);
      expect(passTextField,findsOneWidget);


      await tester.tap(userNameTextField);  // acquire focus
      await tester.enterText(userNameTextField,"heba");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.tap(passTextField);  // acquire focus
      await tester.enterText(passTextField,"12333");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      await Future.delayed(const Duration(seconds:5));
      await  tester.pumpAndSettle();


      final NextButton=await find.byKey(Key('next'));
      expect(NextButton,findsOneWidget);
      await tester.tap(NextButton);

      await Future.delayed(const Duration(seconds:5));
      await  tester.pumpAndSettle();


      final text2=await find.byKey(Key('passOrnameWrong'));
      expect(text2,findsOneWidget);





    });


    testWidgets("login with correct user", (tester) async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      await app.main();
      await Future.delayed(const Duration(seconds:2));
      await  tester.pumpAndSettle();
      final loginButton=await find.byKey(Key('login'));
      expect(loginButton,findsOneWidget);
      tester.tap(loginButton);
      await Future.delayed(const Duration(seconds:3));
      await  tester.pumpAndSettle();


      final userNameTextField=await find.byKey(Key('userName'));
      final passTextField=await find.byKey(Key('pass'));
      expect(userNameTextField,findsOneWidget);
      expect(passTextField,findsOneWidget);


      await tester.tap(userNameTextField);  // acquire focus
      await tester.enterText(userNameTextField,"heba");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.tap(passTextField);  // acquire focus
      await tester.enterText(passTextField,"123");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      await Future.delayed(const Duration(seconds:5));
      await  tester.pumpAndSettle();


      final NextButton=await find.byKey(Key('next'));
      expect(NextButton,findsOneWidget);
      await tester.tap(NextButton);

      //await Future.delayed(const Duration(seconds:10));

      await  tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds:10));
      print("sos");
      final sosPage=await find.byKey(Key('back'));
      expect(sosPage,findsOneWidget);





    });




  });//end group






}