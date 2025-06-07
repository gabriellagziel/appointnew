import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appointnew/features/personal_scheduler/appointments_controller.dart';
import 'package:appointnew/features/personal_scheduler/appointments_repository.dart';

class FakeAppointmentsRepository implements AppointmentsRepository {
  FakeAppointmentsRepository(this.result);
  final List<Appointment> result;
  @override
  Future<List<Appointment>> fetchAppointments() async => result;
}

class ThrowingAppointmentsRepository implements AppointmentsRepository {
  @override
  Future<List<Appointment>> fetchAppointments() =>
      throw Exception('failed');
}

void main() {
  testWidgets('provider emits data from repository', (tester) async {
    final appointments = [
      Appointment(
        id: '1',
        title: 'One',
        date: DateTime(2023, 1, 1),
        time: '10:00',
        description: 'A',
      ),
      Appointment(
        id: '2',
        title: 'Two',
        date: DateTime(2023, 1, 2),
        time: '11:00',
        description: 'B',
      ),
    ];

    final container = ProviderContainer(overrides: [
      appointmentsRepositoryProvider.overrideWithValue(
        FakeAppointmentsRepository(appointments),
      ),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const SizedBox.shrink(),
      ),
    );
    await tester.pumpAndSettle();

    final value = container.read(personalAppointmentsControllerProvider);
    expect(value.asData?.value, appointments);
  });

  testWidgets('provider emits error from repository', (tester) async {
    final container = ProviderContainer(overrides: [
      appointmentsRepositoryProvider.overrideWith(
        (ref) => ThrowingAppointmentsRepository(),
      ),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const SizedBox.shrink(),
      ),
    );
    await tester.pumpAndSettle();

    final value = container.read(personalAppointmentsControllerProvider);
    expect(value.hasError, true);
  });
}
