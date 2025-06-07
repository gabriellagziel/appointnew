import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/firebase_providers.dart';
import '../domain/appointment.dart';

final appointmentsProvider = StreamProvider<List<Appointment>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(authStateProvider).value;

  if (auth == null) {
    return const Stream.empty();
  }

  return firestore
      .collection('appointments')
      .where('userId', isEqualTo: auth.uid)
      .orderBy('datetime', descending: false)
      .limit(5)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.id, doc.data()))
          .toList());
});
