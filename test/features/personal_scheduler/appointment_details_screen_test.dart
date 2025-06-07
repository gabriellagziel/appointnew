import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:appointnew/features/personal_scheduler/appointment_details_screen.dart';
import 'package:appointnew/features/personal_scheduler/appointments_provider.dart';
import 'package:appointnew/features/personal_scheduler/domain/appointment.dart';

void main() {
  testWidgets('AppointmentDetailsScreen displays appointment data', (tester) async {
    const testAppointment = Appointment(
      id: '1',
      title: 'Test Appointment',
      date: '2023-01-01',
      time: '10:00',
      description: 'Description',
    );

    final container = ProviderContainer(overrides: [
      appointmentsProvider('1').overrideWithValue(const AsyncValue.data(testAppointment)),
    ]);

    final router = GoRouter(
      initialLocation: '/personal/details/1',
      routes: [
        GoRoute(
          path: '/personal/details/:id',
          builder: (context, state) => const AppointmentDetailsScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text('Test Appointment'), findsOneWidget);
    expect(find.text('2023-01-01'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });
}
