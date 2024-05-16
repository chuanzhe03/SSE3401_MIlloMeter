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
        await tester.tap(find.byType(Checkbox));
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(activePage), findsOneWidget);

        await tester.enterText(find.byType(TextField).at(0), "2");

        await tester.enterText(find.byType(TextField).at(1), "1");

        await tester.enterText(find.byType(TextField).at(2), "4");

        await tester.enterText(find.byType(TextField).at(3), "2");

        await tester.enterText(find.byType(TextField).at(4), "2");

        await tester.enterText(find.byType(TextField).at(5), "1");

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(firstPage).at(1), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byIcon(Icons.factory).at(0));
        await tester.tap(find.byIcon(Icons.factory).at(1));
        await tester.tap(find.byIcon(Icons.factory).at(2));
        await Future.delayed(const Duration(seconds: 2));

        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        expect(find.byType(firstPage).at(0), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(invitation), findsOneWidget);

        await Future.delayed(const Duration(seconds: 1));
        await tester.enterText(find.byType(TextField).at(0), "Lim");
        await Future.delayed(const Duration(seconds: 1));
        await tester.enterText(find.byType(IntlPhoneField).at(1), "532355522");
        await Future.delayed(const Duration(seconds: 1));
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(firstPage).at(0), findsOneWidget);

        await Future.delayed(const Duration(seconds: 1));
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();

        expect(find.byType(firstPage).at(2), findsOneWidget);

        await Future.delayed(const Duration(seconds: 1));
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsWidgets);

        await Future.delayed(const Duration(seconds: 1));
        await tester.enterText(find.byType(TextField).at(1), "34");
        await Future.delayed(const Duration(seconds: 3));
        await tester.tap(find.byType(ElevatedButton));
      },
    );
  });
}
