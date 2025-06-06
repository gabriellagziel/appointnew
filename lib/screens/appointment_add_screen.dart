import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';

class AppointmentAddScreen extends StatefulWidget {
  const AppointmentAddScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentAddScreen> createState() => _AppointmentAddScreenState();
}

class _AppointmentAddScreenState extends State<AppointmentAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _id = '';
  String _clientName = '';
  DateTime? _dateTime;

  bool get _isFormValid =>
      _id.isNotEmpty && _clientName.isNotEmpty && _dateTime != null;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;

    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _saveAppointment(BuildContext context) {
    if (!_formKey.currentState!.validate() || _dateTime == null) {
      return;
    }
    _formKey.currentState!.save();
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    try {
      provider.addAppointment(_id, _clientName, _dateTime!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _dateTime == null
        ? 'Select Date & Time'
        : DateFormat.yMd().add_jm().format(_dateTime!);

    return ChangeNotifierProvider(
      create: (_) => AppointmentProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Appointment')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ID'),
                  onSaved: (value) => _id = value!.trim(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an ID';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _id = value.trim()),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Client Name'),
                  onSaved: (value) => _clientName = value!.trim(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the client\'s name';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => _clientName = value.trim()),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(dateText),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: _pickDateTime,
                      child: const Text('Pick Date & Time'),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? () => _saveAppointment(context) : null,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
