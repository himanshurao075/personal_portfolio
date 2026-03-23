import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:himanshu_portfolio/src/app.dart';

void main() {
  testWidgets('portfolio app renders loading state', (tester) async {
    await tester.pumpWidget(const HimanshuPortfolioApp());

    expect(find.text('Himanshu Rav Portfolio'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
