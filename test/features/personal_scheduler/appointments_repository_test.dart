import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:appointnew/features/personal_scheduler/data/appointments_repository.dart';
import 'package:appointnew/features/personal_scheduler/domain/appointment.dart';

void main() {
  group('AppointmentsRepository', () {
    test('fetchUpcoming returns appointments from firestore', () async {
      final firestore = FakeFirebaseFirestore();
      final futureDate = DateTime.now().add(const Duration(days: 1));
      await firestore.collection('appointments').doc('1').set({
        'title': 'Test',
        'startTime': Timestamp.fromDate(futureDate),
      });

      final repo = AppointmentsRepository(firestore: firestore);
      final results = await repo.fetchUpcoming();

      expect(results, hasLength(1));
      expect(results.first.title, 'Test');
    });
  });
}

