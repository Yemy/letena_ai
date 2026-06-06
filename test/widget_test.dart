import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serene_ai/main.dart';

void main() {
  testWidgets('SERENE AI app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SereneApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
