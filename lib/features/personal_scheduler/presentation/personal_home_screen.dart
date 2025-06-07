import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/appointments_provider.dart';

/// Displays the personal scheduler home screen with a calendar and upcoming appointments.
class PersonalHomeScreen extends ConsumerWidget {
  const PersonalHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Schedule')),
      body: appointments.when(
        data: (list) => Column(
          children: [
            CalendarWidget(
              onDateSelected: (_) {},
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final appointment = list[index];
                  return ListTile(
                    title: Text(appointment.toString()),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(child: Text('Error loading appointments')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/personal/booking'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CalendarWidget({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      onDateChanged: onDateSelected,
    );
  }
}
