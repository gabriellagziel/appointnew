import 'package:flutter/material.dart';

import '../models/appointment.dart';

class AppointmentProvider with ChangeNotifier {
  final Map<String, Appointment> _appointments = {};

  List<Appointment> get appointments => _appointments.values.toList();

  /// Update an existing appointment. Simulates async operation.
  Future<void> updateAppointment(Appointment appointment) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _appointments[appointment.id] = appointment;
    notifyListeners();
  }

  Appointment? getAppointmentById(String id) {
    return _appointments[id];
  }
}
