import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jobhop/company/pages/home.dart';


Widget testWidget = MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(home: Home())
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home widget shows login buttons', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle(Duration(seconds: 2));

    const facebookKey = Key('facebookButton');
    expect(find.byKey(facebookKey), findsOneWidget);
  });
}
