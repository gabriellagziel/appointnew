import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'domain/appointment.dart';
import 'data/appointments_provider.dart';

class AppointmentEditScreen extends ConsumerWidget {
  AppointmentEditScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).params['id']!;
    final appointmentAsync = ref.watch(appointmentsProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Appointment')),
      body: appointmentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (appointment) {
          String title = appointment.title;
          DateTime date = appointment.date;
          TimeOfDay time = appointment.time;
          String description = appointment.description;

          TimeOfDay _parseTime(String value, TimeOfDay fallback) {
            final parts = value.split(':');
            if (parts.length >= 2) {
              final h = int.tryParse(parts[0]);
              final m = int.tryParse(parts[1]);
              if (h != null && m != null) {
                return TimeOfDay(hour: h, minute: m);
              }
            }
            return fallback;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: appointment.title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    onSaved: (v) => title = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Title required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue:
                        appointment.date.toIso8601String().split('T').first,
                    decoration: const InputDecoration(labelText: 'Date'),
                    onSaved: (v) =>
                        date = DateTime.tryParse(v ?? '') ?? appointment.date,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: appointment.time.format(context),
                    decoration: const InputDecoration(labelText: 'Time'),
                    onSaved: (v) => time =
                        v != null ? _parseTime(v, appointment.time) : time,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: appointment.description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    onSaved: (v) => description = v ?? '',
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final updated = appointment.copyWith(
                          title: title,
                          date: date,
                          time: time,
                          description: description,
                        );
                        await ref
                            .read(appointmentsRepositoryProvider)
                            .update(updated);
                        if (context.mounted) context.pop();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
