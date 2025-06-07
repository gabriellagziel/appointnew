import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appointnew/features/personal_scheduler/appointment_edit_screen.dart';
import 'package:appointnew/core/models/appointment.dart';
import 'package:appointnew/providers/appointments_provider.dart';

void main() {
  final testAppointment = Appointment(
    id: '1',
    title: 'Test',
    date: '2023-01-01',
    time: '10:00',
    description: 'desc',
  );

  testWidgets('loads and displays appointment data', (tester) async {
    final container = ProviderContainer(overrides: [
      appointmentsProvider('1').overrideWithValue(AsyncValue.data(testAppointment)),
    ]);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/personal/edit/:id',
          builder: (context, state) => const AppointmentEditScreen(),
        ),
      ],
      initialLocation: '/personal/edit/1',
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pump(); // loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(); // loaded
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
