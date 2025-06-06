import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/appointment.dart';

class AppointmentService {
  static const String baseUrl = "https://api.example.com/appointments";

  Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch appointments: ${response.statusCode}');
    }
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) {
      return Appointment(
        id: json['id'] as String,
        clientName: json['clientName'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
      );
    }).toList();
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': appointment.id,
        'clientName': appointment.clientName,
        'dateTime': appointment.dateTime.toIso8601String(),
      }),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create appointment: ${response.statusCode}');
    }
    final Map<String, dynamic> jsonMap = jsonDecode(response.body);
    return Appointment(
      id: jsonMap['id'] as String,
      clientName: jsonMap['clientName'] as String,
      dateTime: DateTime.parse(jsonMap['dateTime'] as String),
    );
  }
}
