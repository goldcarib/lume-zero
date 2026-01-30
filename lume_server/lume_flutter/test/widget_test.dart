// Basic test for Lume app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_server_client/lume_server_client.dart';
import 'package:lume_flutter/main.dart';

void main() {
  testWidgets('Lume app smoke test', (WidgetTester tester) async {
    // Create a mock client for testing
    final client = Client('http://localhost:8080/');
    
    // Build our app and trigger a frame
    await tester.pumpWidget(LumeApp(serverpodClient: client));

    // Verify that the entry screen is shown
    expect(find.text('LUME'), findsOneWidget);
    expect(find.text('Collaborative Real-Time Assistant'), findsOneWidget);
    expect(find.text('JOIN SESSION'), findsOneWidget);
  });
}
