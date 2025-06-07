import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentListItem extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;

  const AppointmentListItem({
    Key? key,
    required this.appointment,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeString = '${appointment.dateTime.hour.toString().padLeft(2, '0')}:${appointment.dateTime.minute.toString().padLeft(2, '0')}';
    return ListTile(
      title: Text(appointment.title),
      subtitle: Text(timeString),
      onTap: onTap,
    );
  }
}
