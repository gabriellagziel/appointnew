import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../repositories/appointment_repository.dart';

/// AppointmentProvider manages a list of appointments and notifies listeners
/// whenever the list changes. It relies on AppointmentRepository for data operations.
class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository;
  List<Appointment> _appointments = [];

  /// Constructor accepts an instance of AppointmentRepository.
  AppointmentProvider({required AppointmentRepository repository})
      : _repository = repository;

  /// Returns an unmodifiable view of the appointments list.
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  /// Loads all appointments from the repository and notifies listeners.
  Future<void> loadAppointments() async {
    try {
      final fetched = await _repository.getAllAppointments();
      _appointments = fetched;
      notifyListeners();
    } catch (e) {
      // You can add error handling or logging here if needed.
      rethrow;
    }
  }

  /// Adds a new appointment by calling the repository, updates the internal list,
  /// and notifies listeners.
  Future<void> addAppointment(Appointment appointment) async {
    try {
      final created = await _repository.addAppointment(appointment);
      _appointments.add(created);
      notifyListeners();
    } catch (e) {
      // You can add error handling or logging here if needed.
      rethrow;
    }
  }

  /// Clears the internal appointments list and notifies listeners.
  void clearAppointments() {
    _appointments = [];
    notifyListeners();
  }
}
