import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../providers/appointments_provider.dart';

class AppointmentEditScreen extends ConsumerStatefulWidget {
  const AppointmentEditScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AppointmentEditScreen> createState() => _AppointmentEditScreenState();
}

class _AppointmentEditScreenState extends ConsumerState<AppointmentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _initialized = false;
  DateTime? _date;
  TimeOfDay? _time;
  bool _saving = false;
  late String _appointmentId;

  @override
  void initState() {
    super.initState();
    // Read the appointment id from the current route
    _appointmentId = GoRouterState.of(context).params['id'] ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null) {
      setState(() {
        _date = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _time = time;
      });
    }
  }

  Future<void> _save(Appointment original) async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }
    setState(() {
      _saving = true;
    });
    final updated = original.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _time!.hour,
        _time!.minute,
      ),
    );
    try {
      await ref.read(appointmentsProvider.notifier).updateAppointment(updated);
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return appointmentsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Edit Appointment')),
        body: Center(child: Text('Error: $err')),
      ),
      data: (appointments) {
        final appointment = appointments.firstWhere(
          (a) => a.id == _appointmentId,
          orElse: () => null,
        );
        if (appointment == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Appointment')),
            body: const Center(child: Text('Appointment not found')),
          );
        }
        if (!_initialized) {
          _titleController.text = appointment.title;
          _descriptionController.text = appointment.description;
          _date = appointment.dateTime;
          _time = TimeOfDay.fromDateTime(appointment.dateTime);
          _initialized = true;
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Appointment')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter a title' : null,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Date'),
                      child: Text(_date == null
                          ? 'Select Date'
                          : DateFormat.yMMMd().format(_date!)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Time'),
                      child: Text(
                          _time == null ? 'Select Time' : _time!.format(context)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const Spacer(),
                  _saving
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _save(appointment),
                            child: const Text('Save'),
                          ),
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
