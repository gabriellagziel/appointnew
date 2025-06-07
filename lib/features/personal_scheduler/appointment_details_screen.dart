import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'appointments_provider.dart';
import 'domain/appointment.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).params['id'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final appointmentAsync = ref.watch(appointmentsProvider(id));
          return appointmentAsync.when(
            data: (Appointment appointment) {
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
                    Text('Time: ${appointment.time}'),
                    const SizedBox(height: 16),
                    Text(appointment.description),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Center(child: Text('Error loading appointment')),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            if (id.isNotEmpty) {
              context.go('/personal/edit/$id');
            }
          },
          child: const Text('Edit'),
        ),
      ),
    );
  }
}
