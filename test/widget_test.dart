import 'package:flutter_test/flutter_test.dart';
import 'package:fitbulk_app/main.dart';

void main() {
  testWidgets('StudyTracker smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyTrackerApp());
    expect(find.text('StudyTracker — Bab 6'), findsOneWidget);
  });
}
