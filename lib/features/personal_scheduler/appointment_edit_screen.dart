import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/appointments_provider.dart';

class AppointmentEditScreen extends ConsumerStatefulWidget {
  const AppointmentEditScreen({Key? key, required this.appointmentId}) : super(key: key);

  final String appointmentId;

  @override
  ConsumerState<AppointmentEditScreen> createState() => _AppointmentEditScreenState();
}

class _AppointmentEditScreenState extends ConsumerState<AppointmentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final initial = _selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null || _selectedTime == null) {
      return;
    }
    setState(() {
      _isSaving = true;
      _error = null;
    });
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    final appointment = Appointment(
      id: widget.appointmentId,
      title: _titleController.text.trim(),
      dateTime: dateTime,
      description: _descriptionController.text.trim(),
    );
    try {
      await ref.read(appointmentsServiceProvider).updateAppointment(appointment);
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentAsync = ref.watch(appointmentsProvider(widget.appointmentId));

    return appointmentAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
      data: (appointment) {
        if (_titleController.text.isEmpty) {
          _titleController.text = appointment.title;
          _descriptionController.text = appointment.description;
          _selectedDate = appointment.dateTime;
          _selectedTime = TimeOfDay.fromDateTime(appointment.dateTime);
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Edit Appointment')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (val) => val == null || val.isEmpty ? 'Enter a title' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null
                            ? 'Select Date'
                            : MaterialLocalizations.of(context).formatFullDate(_selectedDate!)),
                      ),
                      TextButton(
                        onPressed: _pickDate,
                        child: const Text('Choose Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_selectedTime == null
                            ? 'Select Time'
                            : _selectedTime!.format(context)),
                      ),
                      TextButton(
                        onPressed: _pickTime,
                        child: const Text('Choose Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _isSaving
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _save,
                          child: const Text('Save'),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
