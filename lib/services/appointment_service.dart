import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/appointment.dart';

/// AppointmentService is responsible for performing HTTP calls
/// to fetch and create appointments via a REST API using JSON.
class AppointmentService {
  final String baseUrl;

  /// Constructor accepts the base URL of the server.
  AppointmentService({required this.baseUrl});

  /// Fetches all appointments from the server endpoint: GET {baseUrl}/appointments
  Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointments'));

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body) as List<dynamic>;
      return decoded.map((jsonMap) => Appointment.fromJson(jsonMap)).toList();
    } else {
      throw Exception('Failed to load appointments (${response.statusCode})');
    }
  }

  /// Creates a new appointment on the server with POST {baseUrl}/appointments
  Future<Appointment> createAppointment(Appointment appointment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(appointment.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> decoded = json.decode(response.body) as Map<String, dynamic>;
      return Appointment.fromJson(decoded);
    } else {
      throw Exception('Failed to create appointment (${response.statusCode})');
    }
  }
}
