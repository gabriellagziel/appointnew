import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String clientName;
  final DateTime dateTime;

  Appointment({required this.id, required this.clientName, required this.dateTime});
}

class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  void addAppointment(String id, String clientName, DateTime dateTime) {
    final newAppointment = Appointment(id: id, clientName: clientName, dateTime: dateTime);
    _appointments.add(newAppointment);
    notifyListeners();
  }
}
