import 'package:aurelia_residence/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Meikarta demo reaches role selection', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AureliaApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Apartemen Meikarta'), findsOneWidget);
    expect(find.text('Choose demo role'), findsOneWidget);
    expect(find.text('Resident'), findsOneWidget);
  });
}
