// lib/presentation/EccScreen.dart

import 'package:flutter/material.dart';

class EccScreen extends StatefulWidget {
  const EccScreen({Key? key}) : super(key: key);

  @override
  _EccScreenState createState() => _EccScreenState();
}

class _EccScreenState extends State<EccScreen> {
  bool _onCampus = true;
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Active', 'Upcoming', 'Highlighted'];

  static const Color _blue = Color(0xFF1677FF);
  static const Color _lightBlue = Color(0xFFE4EEFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Title + subtitle
                const Text(
                  'Event, Competitions & Challenges',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFF121212),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Participate and Showcase Your Talents',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),

                const SizedBox(height: 24),

                // On Campus / Beyond Campus toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EEFF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      _buildToggleButton('On Campus', _onCampus, () {
                        setState(() => _onCampus = true);
                      }),
                      const SizedBox(width: 8),
                      _buildToggleButton('Beyond Campus', !_onCampus, () {
                        setState(() => _onCampus = false);
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Updates label
                const Text(
                  'Updates',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Filter chips
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final selected = i == _selectedFilter;
                      return ChoiceChip(
                        label: Text(
                          _filters[i],
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: selected ? _blue : Colors.black54,
                          ),
                        ),
                        selected: selected,
                        onSelected: (_) {
                          setState(() => _selectedFilter = i);
                        },
                        selectedColor: _lightBlue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: selected ? _blue : Colors.grey.shade300,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Search field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Event list
                Expanded(
                  child: ListView.separated(
                    itemCount: 3, // your dynamic count
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, __) => const EventCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating “+” button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // your onPressed
        },
        backgroundColor: _blue,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? _blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: active ? _blue : Colors.transparent),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: active ? _blue : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  static const Color gradStart = Color(0xFF8C36FF);
  static const Color gradEnd   = Color(0xFF3F9CFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset(
              'assets/images/eventimg.png',
              height: 160,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Annual tech Symposium 2024',
              style: TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Institute chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Indian Institute of Technology Bombay',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _DetailRow(
                  icon: Icons.calendar_today,
                  bgColor: Color(0xFF3F51B5),
                  text: '15 July 2024 at 4:00pm',
                ),
                SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.location_on,
                  bgColor: Color(0xFF4CAF50),
                  text: 'Mumbai Convention Center, Mumbai',
                ),
                SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.apartment,
                  bgColor: Color(0xFF000000),
                  text: 'Indian Institute of Technology Bombay',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // View Details button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [gradStart, gradEnd],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: const Center(
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final String text;

  const _DetailRow({
    required this.icon,
    required this.bgColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'segeo',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
