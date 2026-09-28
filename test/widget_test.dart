import 'package:flutter_test/flutter_test.dart';

import 'package:country_trivia/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const CountryTriviaApp());
    await tester.pump();

    expect(find.text('Country Flag Trivia'), findsOneWidget);
  });
}
