class Event {
  final int? id;
  final String name;
  final String date;
  final String time;
  final String venue;
  final String description;

  Event({this.id, required this.name, required this.date, required this.time, required this.venue, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'venue': venue,
      'description': description,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      time: map['time'],
      venue: map['venue'],
      description: map['description'],
    );
  }
} 