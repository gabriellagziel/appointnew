import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/appointment.dart';
import '../../providers/appointments_provider.dart';

class AppointmentEditScreen extends ConsumerWidget {
  const AppointmentEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).params['id'] ?? '';
    final appointmentAsync = ref.watch(appointmentsProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Appointment'),
      ),
      body: appointmentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appointment) {
          final titleController = TextEditingController(text: appointment.title);
          final dateController = TextEditingController(text: appointment.date);
          final timeController = TextEditingController(text: appointment.time);
          final descController = TextEditingController(text: appointment.description);
          final formKey = GlobalKey<FormState>();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(labelText: 'Date'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: timeController,
                    decoration: const InputDecoration(labelText: 'Time'),
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final updated = Appointment(
                        id: appointment.id,
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                        description: descController.text,
                      );
                      await ref
                          .read(appointmentsProvider(id).notifier)
                          .update(updated);
                      if (context.mounted) {
                        context.go('/personal/details/$id');
                      }
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

