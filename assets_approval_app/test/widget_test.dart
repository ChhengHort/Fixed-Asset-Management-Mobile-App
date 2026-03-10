import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assets_approval_app/src/screens/login_screen.dart';
import 'package:assets_approval_app/src/screens/dashboard_screen.dart';
import 'package:assets_approval_app/src/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Login Screen has a title and a login form', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(LoginForm), findsOneWidget);
  });

  testWidgets('Dashboard Screen displays the bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DashboardScreen()));

    expect(find.byType(BottomNavBar), findsOneWidget);
  });
}