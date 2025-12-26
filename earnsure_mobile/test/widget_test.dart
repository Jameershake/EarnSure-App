import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:earnsure_mobile/main.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(prefs: prefs));

    // Verify that splash screen is showing
    expect(find.text('EarnSure'), findsOneWidget);
    expect(find.text('Fair Wages for All'), findsOneWidget);
  });
}
