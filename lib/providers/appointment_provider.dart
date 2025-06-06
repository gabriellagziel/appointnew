import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../repositories/appointment_repository.dart';
import '../services/appointment_service.dart';

/// AppointmentProvider is responsible for managing the list of appointments,
/// fetching them from the repository, adding new ones, and notifying listeners
/// when the data changes.
class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository(AppointmentService());

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Returns a copy of the current list of appointments.
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  /// Indicates whether a fetch or create operation is in progress.
  bool get isLoading => _isLoading;

  /// Holds the last error message, if any.
  String? get errorMessage => _errorMessage;

  /// Fetches all appointments from the repository and updates state.
  Future<void> loadAppointments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<Appointment> fetched = await _repository.getAllAppointments();
      _appointments = fetched;
    } catch (e) {
      _errorMessage = 'Failed to load appointments: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new appointment via the repository and adds it to the local list.
  Future<void> addAppointment(Appointment appointment) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Appointment created = await _repository.addAppointment(appointment);
      _appointments.add(created);
    } catch (e) {
      _errorMessage = 'Failed to create appointment: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
