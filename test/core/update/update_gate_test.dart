import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/update/app_version.dart';
import 'package:pure_pantry/core/update/update_check_service.dart';
import 'package:pure_pantry/core/update/update_gate.dart';

void main() {
  late UpdateCheckService service;

  setUp(() => service = UpdateCheckService(keyPrefix: 'test', clientKey: 'test'));

  Widget app() => MaterialApp(
        builder: (context, child) =>
            UpdateGate(appName: 'Test App', service: service, child: child!),
        home: const Scaffold(body: Text('home')),
      );

  testWidgets('shows the app alone when up to date', (tester) async {
    await tester.pumpWidget(app());
    expect(find.text('home'), findsOneWidget);
    expect(find.text('Update required'), findsNothing);
    expect(find.text('A new version of Test App is available.'), findsNothing);
  });

  testWidgets('offers an update when one is recommended', (tester) async {
    await tester.pumpWidget(app());
    service.status.value = UpdateStatus.recommended;
    await tester.pump();
    expect(find.text('A new version of Test App is available.'), findsOneWidget);
    expect(find.text('Later'), findsOneWidget);
  });

  testWidgets('covers the app when the minimum is raised while open',
      (tester) async {
    await tester.pumpWidget(app());
    service.status.value = UpdateStatus.required;
    await tester.pump();
    expect(find.text('Update required'), findsOneWidget);
    expect(find.text('Later'), findsNothing);
  });
}
