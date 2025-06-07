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
      title: 'Test',
      date: '2023-01-01',
      time: '10:00 AM',
      description: 'Desc',
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/personal/details/:id',
          builder: (context, state) => const AppointmentDetailsScreen(),
        ),
      ],
      initialLocation: '/personal/details/1',
    );

    final container = ProviderContainer(overrides: [
      appointmentsProvider('1').overrideWithValue(const AsyncValue.data(testAppointment)),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });
}
