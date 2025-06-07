import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/appointments_repository.dart';
import 'domain/appointment.dart';

final appointmentsRepositoryProvider =
    Provider<AppointmentsRepository>((ref) => AppointmentsRepository());

final appointmentsProvider =
    StreamProvider<List<Appointment>>((ref) {
  final repo = ref.watch(appointmentsRepositoryProvider);
  return repo.watchUpcoming();
});

