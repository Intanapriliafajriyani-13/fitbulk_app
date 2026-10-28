import 'package:flutter_test/flutter_test.dart';
import 'package:fitbulk_app/main.dart';

void main() {
  testWidgets('FitBulk smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitBulkApp());
    await tester.pumpAndSettle();
    expect(find.text('FitBulk — Nutrition & Workout'), findsOneWidget);
  });
}
