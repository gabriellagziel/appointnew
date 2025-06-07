import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/appointments_repository.dart';
import '../model/appointment.dart';

final personalAppointmentsControllerProvider = StateNotifierProvider<
    PersonalAppointmentsController, AsyncValue<List<Appointment>>>((ref) {
  final repository = ref.read(appointmentsRepositoryProvider);
  return PersonalAppointmentsController(repository);
});

class PersonalAppointmentsController
    extends StateNotifier<AsyncValue<List<Appointment>>> {
  final AppointmentsRepository _repository;

  PersonalAppointmentsController(this._repository)
      : super(const AsyncLoading()) {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      final appointments = await _repository.fetchAppointments();
      state = AsyncData(appointments);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await _repository.addAppointment(appointment);
      await loadAppointments();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await _repository.updateAppointment(appointment);
      await loadAppointments();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _repository.deleteAppointment(id);
      await loadAppointments();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

