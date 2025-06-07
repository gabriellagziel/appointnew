import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:appointnew/features/personal_scheduler/appointment_details_screen.dart';
import 'package:appointnew/features/personal_scheduler/appointments_provider.dart';
import 'package:appointnew/features/personal_scheduler/domain/appointment.dart';

void main() {
  testWidgets('Appointment details display', (tester) async {
    final testAppointment = Appointment(
      id: '1',
      title: 'Test Title',
      date: DateTime(2023, 1, 1),
      time: '10:00 AM',
      description: 'Test Description',
    );

    final container = ProviderContainer(overrides: [
      appointmentsProvider.overrideWithProvider(
        (id) => FutureProvider<Appointment>((ref) async => testAppointment),
      ),
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

    await tester.pumpAndSettle();

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('10:00 AM'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });
}
