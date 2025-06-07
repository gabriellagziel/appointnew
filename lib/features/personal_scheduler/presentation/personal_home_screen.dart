import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import '../../auth/auth_wrapper.dart';
import '../application/appointments_provider.dart';
import '../domain/appointment.dart';

class PersonalHomeScreen extends ConsumerWidget {
  const PersonalHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return const AuthWrapper();
    }

    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authServiceProvider).signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const CalendarWidget(),
          const SizedBox(height: 16),
          Expanded(
            child: appointmentsAsync.when(
              data: (appointments) {
                if (appointments.isEmpty) {
                  return const Center(child: Text('No upcoming appointments'));
                }
                return ListView(
                  children: appointments
                      .map((a) => AppointmentCard(appointment: a))
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AppointmentBookingScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 200, child: Center(child: Text('Calendar')));
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(appointment.title),
      subtitle: Text(
          '${appointment.datetime.toLocal()}'.split('.').first),
    );
  }
}

class AppointmentBookingScreen extends StatelessWidget {
  const AppointmentBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: const Center(child: Text('Booking screen placeholder')),
    );
  }
}
