import 'package:flutter/material.dart';
import 'event_model.dart';
import 'db_helper.dart';
import 'event_details_screen.dart';
import 'admin_panel_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isAdmin = false;
  late Future<List<Event>> eventsFuture;
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    eventsFuture = DBHelper.getEventsDescending();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void refreshEvents() {
    setState(() {
      eventsFuture = DBHelper.getEventsDescending();
      _controller.reset();
      _controller.forward();
    });
  }

  void searchByDate(String date) {
    setState(() {
      if (date.isEmpty) {
        eventsFuture = DBHelper.getEventsDescending();
      } else {
        eventsFuture = DBHelper.searchEventsByDate(date);
      }
      _controller.reset();
      _controller.forward();
    });
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F8FFF), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Management',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover & Register',
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Admin',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Switch(
                value: isAdmin,
                activeColor: Colors.white,
                onChanged: (val) {
                  setState(() {
                    isAdmin = val;
                  });
                  if (val) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminPanelScreen(onUpdate: refreshEvents),
                      ),
                    ).then((_) {
                      setState(() {
                        isAdmin = false;
                      });
                      refreshEvents();
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Interval(index * 0.08, 1, curve: Curves.easeOut)),
      ),
      child: Card(
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
          title: Text(
            event.name,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.indigo.shade300),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      event.date,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.indigo.shade300),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      event.time,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.indigo.shade300),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      event.venue,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF6C63FF)),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailsScreen(event: event),
              ),
            );
            refreshEvents();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        body: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by date (YYYY-MM-DD)',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            searchByDate('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: searchByDate,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
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
                    itemBuilder: (context, index) => _buildEventCard(events[index], index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 