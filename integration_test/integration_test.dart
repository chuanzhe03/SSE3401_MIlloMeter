import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lab_5_2/active.dart';
import 'package:lab_5_2/home.dart';
import 'package:lab_5_2/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "Enter the mobile phone number and click the check box",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(activePage), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(loginPage), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(activePage), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(firstPage), findsOneWidget);


    },
  );
}