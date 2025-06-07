import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appointnew/features/personal_scheduler/appointment_edit_screen.dart';
import 'package:appointnew/providers/appointments_provider.dart';

void main() {
  testWidgets('edit screen loads and shows prefilled form', (WidgetTester tester) async {
    final testAppointment = Appointment(
      id: '123',
      title: 'Doctor Visit',
      dateTime: DateTime(2023, 1, 1, 10, 0),
      description: 'Annual checkup',
    );

    final overrides = [
      appointmentsProvider.overrideWithProvider((id) => FutureProvider<Appointment>((ref) async => testAppointment)),
      appointmentsServiceProvider.overrideWithValue(AppointmentsService()),
    ];

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/edit/:id',
          builder: (context, state) {
            return ProviderScope(
              overrides: overrides,
              child: AppointmentEditScreen(appointmentId: state.params['id']!),
            );
          },
        ),
      ],
      initialLocation: '/edit/123',
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Doctor Visit'), findsOneWidget);
    expect(find.text('Annual checkup'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
