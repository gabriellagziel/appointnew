import 'package:flutter_riverpod/flutter_riverpod.dart';

class Appointment {
  final String id;
  final String title;
  final DateTime dateTime;
  final String description;

  Appointment({required this.id, required this.title, required this.dateTime, required this.description});
}

class AppointmentsService {
  Future<Appointment> fetchAppointment(String id) async {
    // TODO: replace with Firestore fetch
    return Appointment(
      id: id,
      title: 'Appointment $id',
      dateTime: DateTime.now(),
      description: 'Description',
    );
  }

  Future<void> updateAppointment(Appointment appointment) async {
    // TODO: implement update logic
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

final appointmentsServiceProvider = Provider<AppointmentsService>((ref) => AppointmentsService());

final appointmentsProvider = FutureProvider.family<Appointment, String>((ref, id) {
  final service = ref.read(appointmentsServiceProvider);
  return service.fetchAppointment(id);
});
