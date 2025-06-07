import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/appointment.dart';

final appointmentsProvider = FutureProvider.family<Appointment, String>((ref, id) async {
  // Replace with real data fetching logic.
  throw UnimplementedError();
});
