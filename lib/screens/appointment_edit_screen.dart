import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/appointment.dart';
import '../providers/appointment_provider.dart';

/// Screen allowing editing of an existing [Appointment].
class AppointmentEditScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentEditScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<AppointmentEditScreen> createState() => _AppointmentEditScreenState();
}

class _AppointmentEditScreenState extends State<AppointmentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DateTime? _selectedDateTime;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.appointment.clientName);
    _selectedDateTime = widget.appointment.dateTime;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Opens date and time pickers to choose a new appointment time.
  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initialDate = _selectedDateTime ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  /// Validates and submits the form to update the appointment.
  Future<void> _saveForm() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || _selectedDateTime == null) return;

    final updated = widget.appointment.copyWith(
      clientName: _nameController.text.trim(),
      dateTime: _selectedDateTime,
    );

    setState(() => _submitting = true);
    try {
      await Provider.of<AppointmentProvider>(context, listen: false)
          .updateAppointment(updated);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update appointment: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  bool get _isSaveEnabled {
    return !_submitting &&
        _nameController.text.trim().isNotEmpty &&
        _selectedDateTime != null &&
        _selectedDateTime!.isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Appointment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSaveEnabled ? _saveForm : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _submitting,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Client Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a client name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Date & Time: ' +
                      (_selectedDateTime != null
                          ? dateFormat.format(_selectedDateTime!)
                          : 'Not selected'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Select Date & Time'),
                ),
                const Spacer(),
                if (_submitting)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
