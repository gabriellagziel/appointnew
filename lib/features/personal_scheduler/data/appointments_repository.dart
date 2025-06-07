import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/appointment.dart';

class AppointmentsRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('appointments');

  Stream<List<Appointment>> watchAppointments() {
    try {
      return _collection.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Appointment.fromJson(doc.data())).toList());
    } catch (e) {
      rethrow;
    }
  }

  Future<Appointment> fetchAppointment(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) {
        throw Exception('Appointment not found');
      }
      return Appointment.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveAppointment(Appointment appointment) async {
    try {
      await _collection.doc(appointment.id).set(appointment.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}

final appointmentsRepositoryProvider =
    Provider<AppointmentsRepository>((ref) => AppointmentsRepository());
