import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String userId;
  final String title;
  final DateTime datetime;

  Appointment({
    required this.id,
    required this.userId,
    required this.title,
    required this.datetime,
  });

  factory Appointment.fromFirestore(String id, Map<String, dynamic> data) {
    return Appointment(
      id: id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      datetime: (data['datetime'] as Timestamp).toDate(),
    );
  }
}
