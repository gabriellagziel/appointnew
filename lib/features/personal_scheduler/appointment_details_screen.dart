import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'appointments_provider.dart';
import 'domain/appointment.dart';

class AppointmentDetailsScreen extends ConsumerWidget {
  const AppointmentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read appointment id from route parameters
    final id = context.goRouter
        .namedLocation('personal/details')
        .params['id'];

    final appointmentAsync = ref.watch(appointmentsProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: appointmentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (appointment) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8),
              Text(appointment.date.toString()),
              const SizedBox(height: 8),
              Text(appointment.time.toString()),
              const SizedBox(height: 8),
              Text(appointment.description),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/personal/edit/$id');
                  },
                  child: const Text('Edit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
