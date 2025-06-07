import 'package:flutter/material.dart';
import 'models/appointment.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.title, style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            Text(appointment.dateTime.toString()),
          ],
        ),
      ),
    );
  }
}
