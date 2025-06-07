import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String description;

  Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
  });

  Appointment copyWith({
    String? id,
    String? title,
    DateTime? date,
    TimeOfDay? time,
    String? description,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
    );
  }
}
