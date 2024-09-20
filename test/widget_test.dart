import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../main.dart';  // Adjust this path to match the location of main.dart

void main() {
  testWidgets('Test for DigitalPetApp', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(MaterialApp(home: DigitalPetApp()));

    // Verify that the app displays the initial pet information
    expect(find.text('Your Pet'), findsOneWidget);
    expect(find.text('Happiness Level: 50'), findsOneWidget);
    expect(find.text('Hunger Level: 50'), findsOneWidget);
  });
}
