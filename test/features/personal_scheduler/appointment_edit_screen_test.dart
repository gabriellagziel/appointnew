import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

import 'package:appointnew/features/personal_scheduler/appointment_edit_screen.dart';
import 'package:appointnew/providers/appointments_provider.dart';

class MockAppointmentsNotifier extends Mock implements AppointmentsNotifier {}

void main() {
  testWidgets('renders edit appointment screen', (tester) async {
    final notifier = MockAppointmentsNotifier();

    final router = GoRouter(
      initialLocation: '/1',
      routes: [
        GoRoute(
          path: '/:id',
          builder: (_, __) => const AppointmentEditScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appointmentsProvider.overrideWith(() => notifier)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Edit Appointment'), findsOneWidget);
  });
}
