import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'appointments_provider.dart';
import 'domain/appointment.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).params['id']!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final appointmentAsync = ref.watch(appointmentsProvider(id));
          return appointmentAsync.when(
            data: (appointment) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 8),
                    Text('Date: ${appointment.date}'),
                    const SizedBox(height: 4),
                    Text('Time: ${appointment.time}'),
                    const SizedBox(height: 16),
                    Text(appointment.description),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => context.push('/personal/edit/$id'),
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }
}
