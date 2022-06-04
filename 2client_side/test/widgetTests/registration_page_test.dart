import 'package:client_side/registration_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:client_side/socket_class.dart';
//import 'package:mockito/mockito.dart';

void main() async{

  Widget makeTestableWidget({Widget? child}){
    return MaterialApp(
      home: child,
    );

  }


  testWidgets("init test", (WidgetTester tester)async {
    final Registor page=Registor();
    await tester.pumpWidget(makeTestableWidget(child: page));
    MaterialColor myMaterialColor=Colors.grey;
    print(myMaterialColor);
    expect((tester.firstWidget(find.byType(Icon)) as Icon).color,myMaterialColor);
    expect(find.text("guest"),findsOneWidget);
    expect(find.text("input phone"),findsOneWidget);
    expect(find.byIcon(Icons.language),findsOneWidget);

  });
  
  testWidgets("enter user name,save button color=green", (WidgetTester tester)async {
    final userNameTextField=find.byKey(const ValueKey('userNameTextField'));
    final Registor page=Registor();
    await tester.pumpWidget(makeTestableWidget(child: page));
    await  tester.enterText(userNameTextField,"nuri");
    await tester.pump();
    print("here1");
    print((tester.firstWidget(find.byType(Icon)) as Icon).color);
    MaterialColor myMaterialColor=Colors.green;
    print(myMaterialColor);
    expect((tester.firstWidget(find.byType(Icon)) as Icon).color,myMaterialColor);
    expect(find.text("nuri"),findsOneWidget);
  });

  testWidgets("enter user name,save button color=green", (WidgetTester tester)async {
    final userNameTextField=find.byKey(const ValueKey('userNameTextField'));
    final Registor page=Registor();
    await tester.pumpWidget(makeTestableWidget(child: page));
    await  tester.enterText(userNameTextField,"nuri");
    await tester.pump();
    print("here1");
    print((tester.firstWidget(find.byType(Icon)) as Icon).color);
    MaterialColor myMaterialColor=Colors.green;
    print(myMaterialColor);
    expect((tester.firstWidget(find.byType(Icon)) as Icon).color,myMaterialColor);
    expect(find.text("nuri"),findsOneWidget);
  });


  testWidgets("no change on username,save button color=grey", (WidgetTester tester)async {

    final Registor page=Registor();
    await tester.pumpWidget(makeTestableWidget(child: page));

    print("here2");
    print((tester.firstWidget(find.byType(Icon)) as Icon).color);
    MaterialColor myMaterialColor=Colors.grey;
    print(myMaterialColor);
    expect((tester.firstWidget(find.byType(Icon)) as Icon).color,myMaterialColor);

  });




}