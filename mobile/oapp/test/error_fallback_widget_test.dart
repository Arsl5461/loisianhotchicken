import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:OApp/widgets/error_fallback_widget.dart';

void main() {
  testWidgets('shows a recovery message and debug details', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ErrorFallbackWidget(
          details: FlutterErrorDetails(
            exception: const FormatException('test failure'),
          ),
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('FormatException: test failure'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
