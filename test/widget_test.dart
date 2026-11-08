import 'package:flutter_test/flutter_test.dart';
import 'package:esg_campus_passport/app.dart';

void main() {
  testWidgets('ESG App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ESGApp());
    expect(find.text('ESG CAMPUS\nPASSPORT'), findsOneWidget);
  });
}
