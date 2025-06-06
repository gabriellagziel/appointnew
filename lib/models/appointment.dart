class Appointment {
  final String id;
  final String clientName;
  final DateTime dateTime;

  Appointment({
    required this.id,
    required this.clientName,
    required this.dateTime,
  });

  Appointment copyWith({String? clientName, DateTime? dateTime}) {
    return Appointment(
      id: id,
      clientName: clientName ?? this.clientName,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
