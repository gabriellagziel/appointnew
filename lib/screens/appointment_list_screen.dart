import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/appointment_provider.dart';

class AppointmentListScreen extends StatelessWidget {
  const AppointmentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppointmentProvider>(
      create: (_) => AppointmentProvider()..loadAppointments(),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<AppointmentProvider>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Appointments'),
            ),
            body: _buildBody(context, provider),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppointmentProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadAppointments(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadAppointments(),
      child: ListView.builder(
        itemCount: provider.appointments.length,
        itemBuilder: (context, index) {
          final appointment = provider.appointments[index];
          final formattedDate =
              DateFormat.yMd().add_jm().format(appointment.dateTime);
          return ListTile(
            title: Text(appointment.clientName),
            subtitle: Text(formattedDate),
          );
        },
      ),
    );
  }
}
