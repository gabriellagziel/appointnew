import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _service;

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  AppointmentProvider(this._service) {
    loadAppointments();
  }

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> loadAppointments() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    try {
      _appointments = await _service.fetchAppointments();
      _errorMessage = '';
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshAppointments() async {
    await loadAppointments();
  }

  Future<bool> addAppointment(Appointment appointment) async {
    try {
      final newAppointment = await _service.createAppointment(appointment);
      _appointments.insert(0, newAppointment);
      notifyListeners();
      return true;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }
}
