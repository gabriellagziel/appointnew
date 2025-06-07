import 'package:flutter/material.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Appointment')),
      body: const Center(
        child: Text('Add appointment form goes here'),
      ),
    );
  }
}
