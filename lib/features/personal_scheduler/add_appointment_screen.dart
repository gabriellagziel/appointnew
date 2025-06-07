import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'models/appointment.dart';
import 'controllers/personal_appointments_controller.dart';

final _titleProvider = StateProvider<String>((ref) => '');
final _descriptionProvider = StateProvider<String>((ref) => '');
final _dateProvider = StateProvider<DateTime?>((ref) => null);
final _timeProvider = StateProvider<TimeOfDay?>((ref) => null);

class AddAppointmentScreen extends ConsumerWidget {
  AddAppointmentScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(_titleProvider);
    final description = ref.watch(_descriptionProvider);
    final date = ref.watch(_dateProvider);
    final time = ref.watch(_timeProvider);

    final isValid =
        title.trim().isNotEmpty && date != null && time != null;

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(_dateProvider.notifier).state = picked;
      }
    }

    Future<void> pickTime() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: time ?? TimeOfDay.now(),
      );
      if (picked != null) {
        ref.read(_timeProvider.notifier).state = picked;
      }
    }

    void save() {
      if (!_formKey.currentState!.validate()) return;
      final appointment = Appointment(
        title: title.trim(),
        date: date!,
        time: time!,
        description: description.trim(),
      );
      context
          .read(PersonalAppointmentsControllerProvider.notifier)
          .addAppointment(appointment);
      context.pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (val) =>
                    ref.read(_titleProvider.notifier).state = val,
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date'),
                  child: Text(
                    date != null
                        ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
                        : 'Select date',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: pickTime,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Time'),
                  child: Text(
                    time != null
                        ? time.format(context)
                        : 'Select time',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (val) =>
                    ref.read(_descriptionProvider.notifier).state = val,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isValid ? save : null,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

