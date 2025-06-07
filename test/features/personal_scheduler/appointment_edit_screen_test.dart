import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appointnew/features/personal_scheduler/appointment_edit_screen.dart';
import 'package:appointnew/features/personal_scheduler/data/appointments_provider.dart';
import 'package:appointnew/features/personal_scheduler/domain/appointment.dart';

void main() {
  testWidgets('edit screen shows appointment data', (tester) async {
    final testAppointment = Appointment(
      id: '1',
      title: 'Meeting',
      date: DateTime(2023, 1, 1),
      time: const TimeOfDay(hour: 10, minute: 30),
      description: 'Discuss project',
    );

    final router = GoRouter(
      initialLocation: '/personal/edit/1',
      routes: [
        GoRoute(
          path: '/personal/edit/:id',
          builder: (context, state) => AppointmentEditScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appointmentsProvider.overrideWithProvider(
            (id) => FutureProvider((ref) async => testAppointment),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Meeting'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
