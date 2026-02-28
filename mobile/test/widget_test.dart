import 'package:flutter_test/flutter_test.dart';
import 'package:hris_mobile/main.dart';

void main() {
  testWidgets('HRIS app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HRISApp());
    expect(find.text('HRIS'), findsOneWidget);
  });
}
