import 'package:flutter/material.dart';

import 'models/appointment.dart';
import 'add_appointment_screen.dart';
import 'appointment_details_screen.dart';
import 'widgets/calendar_view.dart';
import 'widgets/appointment_list_item.dart';

class PersonalHomeScreen extends StatefulWidget {
  const PersonalHomeScreen({Key? key}) : super(key: key);

  @override
  State<PersonalHomeScreen> createState() => _PersonalHomeScreenState();
}

class _PersonalHomeScreenState extends State<PersonalHomeScreen> {
  DateTime _selectedDate = DateTime.now();

  final List<Appointment> _appointments = [
    Appointment(title: 'Dentist Appointment', dateTime: DateTime.now().add(const Duration(hours: 2))),
    Appointment(title: 'Lunch with Sam', dateTime: DateTime.now().add(const Duration(days: 1, hours: 3))),
  ];

  void _onDateSelected(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _openAddAppointment() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
    );
  }

  void _openDetails(Appointment appt) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AppointmentDetailsScreen(appointment: appt)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Schedule')),
      body: Column(
        children: [
          CalendarView(
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appt = _appointments[index];
                return AppointmentListItem(
                  appointment: appt,
                  onTap: () => _openDetails(appt),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAppointment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
