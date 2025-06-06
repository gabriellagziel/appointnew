import '../models/appointment.dart';
import '../services/appointment_service.dart';

/// AppointmentRepository wraps the AppointmentService and provides
/// higher-level methods for fetching and adding appointments.
class AppointmentRepository {
  final AppointmentService _service;

  /// Constructor accepts an instance of AppointmentService.
  AppointmentRepository(this._service);

  /// Returns all appointments by delegating to the service.
  Future<List<Appointment>> getAllAppointments() async {
    try {
      return await _service.fetchAppointments();
    } catch (e) {
      rethrow;
    }
  }

  /// Adds a new appointment by delegating to the service.
  Future<Appointment> addAppointment(Appointment appointment) async {
    try {
      return await _service.createAppointment(appointment);
    } catch (e) {
      rethrow;
    }
  }
}
