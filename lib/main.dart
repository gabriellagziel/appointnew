import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';
import 'screens/appointment_list_screen.dart';
import 'screens/appointment_add_screen.dart';
import 'screens/appointment_edit_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppointmentProvider>(
      create: (_) => AppointmentProvider(),
      child: MaterialApp(
        title: 'Appointment App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AppointmentListScreen(),
        routes: {
          '/add': (_) => const AppointmentAddScreen(),
          '/edit': (_) => const AppointmentEditScreen(),
        },
      ),
    );
  }
}
