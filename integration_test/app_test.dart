import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lab_5_2/active.dart';
import 'package:lab_5_2/home.dart';
import 'package:lab_5_2/invitation.dart';
import 'package:lab_5_2/main.dart' as app;
import 'package:intl_phone_field/intl_phone_field.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("app test", () {
    testWidgets(
      "test normal flow",
          (WidgetTester tester) async {
            app.main();
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(IntlPhoneField), "7583792224");
        await Future.delayed(const Duration(seconds: 3));
        await tester.tap(find.byType(Checkbox));
        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(activePage), findsOneWidget);

        await tester.enterText(find.byType(TextField),"258332");
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(firstPage), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byIcon(Icons.factory).at(0));
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byIcon(Icons.factory).at(1));
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 6));
        await tester.tap(find.byIcon(Icons.factory).at(2));
        await Future.delayed(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byKey(const Key("button settings")));
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 3));
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 4));
        await tester.enterText(find.byType(TextField).at(1), "10");
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 4));
        await tester.tap(find.byKey(const Key("save")));
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 5));

        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 4));
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(invitationPage), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.enterText(find.byKey(const Key("Text field")),'LIM');
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 4));
        await tester.enterText(find.byKey(const Key("phone")), "5325355522");
        await Future.delayed(const Duration(seconds: 5));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key("button")),);
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 3));

        Navigator.of(tester.element(find.byType(Scaffold))).pop();
        await tester.pumpAndSettle();
        expect(find.byType(firstPage), findsOneWidget);
        await Future.delayed(const Duration(seconds: 3));
      },
    );
  });
}
