import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:appointnew/features/personal_scheduler/personal_home_screen.dart';
import 'package:appointnew/features/personal_scheduler/add_appointment_screen.dart';

void main() {
  testWidgets('renders calendar and FAB', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PersonalHomeScreen()));

    expect(find.byType(CalendarView), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('tapping FAB navigates to add screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PersonalHomeScreen()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AddAppointmentScreen), findsOneWidget);
  });
}
