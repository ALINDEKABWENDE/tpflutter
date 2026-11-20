import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tpalindecv/main.dart';

void main() {
  testWidgets('Login page accepts valid credentials', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Connexion'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), kLogin);
    await tester.enterText(find.byType(TextFormField).at(1), kPassword);
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsWidgets);
  });
}
