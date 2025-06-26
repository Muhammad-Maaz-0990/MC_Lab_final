class Registration {
  final int? id;
  final String fullName;
  final String email;
  final int eventId;

  Registration({this.id, required this.fullName, required this.email, required this.eventId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'eventId': eventId,
    };
  }

  factory Registration.fromMap(Map<String, dynamic> map) {
    return Registration(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      eventId: map['eventId'],
    );
  }
} 