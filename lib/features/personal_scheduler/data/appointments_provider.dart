import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../domain/appointment.dart';

class AppointmentsRepository {
  final Map<String, Appointment> _storage = {};

  AppointmentsRepository() {
    final now = DateTime.now();
    _storage['1'] = Appointment(
      id: '1',
      title: 'Test Appointment',
      date: DateTime(now.year, now.month, now.day),
      time: TimeOfDay(hour: now.hour, minute: now.minute),
      description: 'Demo description',
    );
  }

  Future<Appointment> fetchById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _storage[id]!;
  }

  Future<void> update(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _storage[appointment.id] = appointment;
  }
}

final appointmentsRepositoryProvider = Provider<AppointmentsRepository>((ref) {
  return AppointmentsRepository();
});

final appointmentsProvider =
    FutureProvider.family<Appointment, String>((ref, id) async {
  final repo = ref.watch(appointmentsRepositoryProvider);
  return repo.fetchById(id);
});
