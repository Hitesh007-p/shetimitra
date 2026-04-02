import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shetimitra/main.dart';

void main() {
  testWidgets('app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
