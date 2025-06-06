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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider<AppointmentProvider>(
        create: (_) => AppointmentProvider(),
        child: AppointmentListScreen(),
      ),
      routes: {
        '/add': (_) => AppointmentAddScreen(),
        '/edit': (context) {
          final appointment =
              ModalRoute.of(context)!.settings.arguments as Appointment;
          return AppointmentEditScreen(appointment: appointment);
        },
      },
    );
  }
}
