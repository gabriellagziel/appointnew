import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'appointments_provider.dart';
import 'domain/appointment.dart';

/// Screen showing details for a single [Appointment].
class AppointmentDetailsScreen extends ConsumerWidget {
  const AppointmentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouter.of(context).pathParameters['id'] ?? '';
    final AsyncValue<Appointment> appointment =
        ref.watch(appointmentsProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: appointment.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: \$error')),
        data: (appt) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appt.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8),
                        Text('Date: \${appt.date.toLocal()}'),
                        const SizedBox(height: 4),
                        Text('Time: \${appt.time}'),
                        const SizedBox(height: 12),
                        Text(appt.description),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/personal/edit/\$id'),
                    child: const Text('Edit'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
