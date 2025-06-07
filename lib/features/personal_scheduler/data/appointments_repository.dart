import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/appointment.dart';

class AppointmentsRepository {
  AppointmentsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('appointments');

  Stream<List<Appointment>> watchUpcoming() {
    return _collection
        .where('startTime', isGreaterThan: Timestamp.now())
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromJson(doc.data(), doc.id))
            .toList());
  }

  Future<List<Appointment>> fetchUpcoming() async {
    final snapshot = await _collection
        .where('startTime', isGreaterThan: Timestamp.now())
        .orderBy('startTime')
        .get();
    return snapshot.docs
        .map((doc) => Appointment.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<Appointment> fetchById(String id) async {
    final doc = await _collection.doc(id).get();
    final data = doc.data();
    if (data == null) {
      throw StateError('Appointment not found');
    }
    return Appointment.fromJson(data, doc.id);
  }

  Future<void> save(Appointment appointment) async {
    await _collection.doc(appointment.id).set(appointment.toJson());
  }
}

