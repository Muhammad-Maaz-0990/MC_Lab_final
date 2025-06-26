import 'package:flutter/material.dart';
import 'event_model.dart';
import 'db_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanelScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const AdminPanelScreen({super.key, required this.onUpdate});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late Future<List<Event>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = DBHelper.getEvents();
  }

  void refreshEvents() {
    setState(() {
      eventsFuture = DBHelper.getEvents();
    });
    widget.onUpdate();
  }

  void showEventForm({Event? event}) {
    final nameController = TextEditingController(text: event?.name ?? '');
    final dateController = TextEditingController(text: event?.date ?? '');
    final timeController = TextEditingController(text: event?.time ?? '');
    final venueController = TextEditingController(text: event?.venue ?? '');
    final descController = TextEditingController(text: event?.description ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(event == null ? 'Add Event' : 'Edit Event',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              const SizedBox(height: 18),
              TextField(
                controller: nameController,
                style: GoogleFonts.montserrat(fontSize: 16),
                decoration: const InputDecoration(labelText: 'Event Name', prefixIcon: Icon(Icons.event)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dateController,
                style: GoogleFonts.montserrat(fontSize: 16),
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)', prefixIcon: Icon(Icons.calendar_today)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                style: GoogleFonts.montserrat(fontSize: 16),
                decoration: const InputDecoration(labelText: 'Time', prefixIcon: Icon(Icons.access_time)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: venueController,
                style: GoogleFonts.montserrat(fontSize: 16),
                decoration: const InputDecoration(labelText: 'Venue', prefixIcon: Icon(Icons.location_on)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                style: GoogleFonts.montserrat(fontSize: 16),
                decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: event == null ? const Color(0xFF4F8FFF) : Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    final newEvent = Event(
                      id: event?.id,
                      name: nameController.text,
                      date: dateController.text,
                      time: timeController.text,
                      venue: venueController.text,
                      description: descController.text,
                    );
                    if (event == null) {
                      await DBHelper.insertEvent(newEvent);
                    } else {
                      await DBHelper.updateEvent(newEvent);
                    }
                    Navigator.pop(context);
                    refreshEvents();
                  },
                  child: Text(event == null ? 'Add' : 'Update', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DBHelper.deleteEvent(id);
              Navigator.pop(context);
              refreshEvents();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final titleStyle = GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20);
    final bodyStyle = GoogleFonts.montserrat(fontSize: 16);
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF6C63FF),
          child: Icon(Icons.event, color: Colors.white, size: 28),
        ),
        title: Text(event.name, style: titleStyle, overflow: TextOverflow.ellipsis, maxLines: 2),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.indigo.shade300),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(event.date, style: bodyStyle, overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.indigo.shade300),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(event.time, style: bodyStyle, overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.indigo.shade300),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(event.venue, style: bodyStyle, overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () => showEventForm(event: event),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => confirmDelete(event.id!),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F8FFF), Color(0xFF6C63FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Admin Panel', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEventForm(),
        backgroundColor: const Color(0xFF4F8FFF),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFFF6F8FB),
      body: FutureBuilder<List<Event>>(
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          }
          final events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            itemCount: events.length,
            itemBuilder: (context, index) => _buildEventCard(events[index]),
          );
        },
      ),
    );
  }
} 