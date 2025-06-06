import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentRepository {
  final AppointmentService _service;

  AppointmentRepository(this._service);

  Future<List<Appointment>> getAllAppointments() async {
    return await _service.fetchAppointments();
  }

  Future<Appointment> addAppointment(Appointment appointment) async {
    return await _service.createAppointment(appointment);
  }
}
