import 'package:flutter_test/flutter_test.dart';
import 'package:tobacco_barn_calculator/main.dart';
import 'package:tobacco_barn_calculator/screens/home_screen.dart';
import 'package:tobacco_barn_calculator/screens/splash_screen.dart';

void main() {
  testWidgets('App launches from splash to home', (tester) async {
    await tester.pumpWidget(const TobaccoBarnCalculatorApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Tobacco Barn Analyser'), findsOneWidget);
  });
}
