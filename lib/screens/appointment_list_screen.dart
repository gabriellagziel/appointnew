import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../models/appointment.dart';
import 'appointment_detail_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  late AppointmentProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = AppointmentProvider();
    _provider.loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppointmentProvider>.value(
      value: _provider,
      child: Consumer<AppointmentProvider>(
        builder: (context, provider, _) {
          if (provider.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Failed to load appointments. Try again.'),
              ),
            );
          }
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Appointments')),
            body: ListView.builder(
              itemCount: provider.appointments.length,
              itemBuilder: (context, index) {
                final Appointment appointment = provider.appointments[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      '${appointment.dateTime.year.toString().padLeft(4, '0')}-'
                      '${appointment.dateTime.month.toString().padLeft(2, '0')}-'
                      '${appointment.dateTime.day.toString().padLeft(2, '0')} '
                      '${appointment.dateTime.hour.toString().padLeft(2, '0')}:'
                      '${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                    ),
                    subtitle: Text(appointment.clientName),
                    trailing: Text(appointment.id),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AppointmentDetailScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: provider.refreshAppointments,
              child: const Icon(Icons.refresh),
            ),
          );
        },
      ),
    );
  }
}
