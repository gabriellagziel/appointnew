class Appointment {
  final String id;
  final String clientName;
  final DateTime dateTime;

  const Appointment({
    required this.id,
    required this.clientName,
    required this.dateTime,
  });

  @override
  String toString() {
    return 'Appointment(id: $id, clientName: $clientName, dateTime: $dateTime)';
  }
}
