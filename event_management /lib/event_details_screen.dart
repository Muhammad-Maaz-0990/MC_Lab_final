import 'package:flutter/material.dart';
import 'event_model.dart';
import 'registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20);
    final bodyStyle = GoogleFonts.montserrat(fontSize: 16);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Hero(
          tag: 'event_${event.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Text(event.name, style: titleStyle.copyWith(color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
        ),
        backgroundColor: const Color(0xFF4F8FFF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'event_${event.id}',
                  child: Text(event.name, style: titleStyle, overflow: TextOverflow.ellipsis, maxLines: 2),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.indigo.shade400),
                    const SizedBox(width: 8),
                    Flexible(child: Text(event.date, style: bodyStyle, overflow: TextOverflow.ellipsis, maxLines: 1)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.indigo.shade400),
                    const SizedBox(width: 8),
                    Flexible(child: Text(event.time, style: bodyStyle, overflow: TextOverflow.ellipsis, maxLines: 1)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.indigo.shade400),
                    const SizedBox(width: 8),
                    Flexible(child: Text(event.venue, style: bodyStyle, overflow: TextOverflow.ellipsis, maxLines: 1)),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(event.description, style: bodyStyle),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F8FFF), Color(0xFF6C63FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.event_available),
                      label: const Text('Register'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegistrationScreen(event: event),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 