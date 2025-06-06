import '../models/appointment.dart';

abstract class AppointmentService {
  Future<List<Appointment>> fetchAppointments();
  Future<Appointment> createAppointment(Appointment appointment);
}
