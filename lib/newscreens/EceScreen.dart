import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EceScreen extends StatefulWidget {
  const EceScreen({super.key});
  @override
  State<EceScreen> createState() => _EceScreenState();
}

class _EceScreenState extends State<EceScreen> {
  // 0 = On Campuses, 1 = Beyond Campuses
  int _campusIndex = 0;
  // 0 = All, 1 = Active, 2 = Upcoming, 3 = Highlighted
  int _filterIndex = 0;
  final _searchCtrl = TextEditingController();

  final List<String> _filterLabels = [
    'All',
    'Active',
    'Upcoming',
    'Highlighted',
  ];

  @override
  Widget build(BuildContext context) {
    final blue = const Color(0xFF4A90E2);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & subtitle
              const Text(
                'Event, Competitions & Challenges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Participate and Showcase Your Talents',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 24),

              // Segmented control
              Row(
                children: [
                  _buildSegment('On Campuses', 0),
                  const SizedBox(width: 8),
                  _buildSegment('Beyond Campuses', 1),
                ],
              ),

              const SizedBox(height: 32),

              // Updates label
              const Text(
                'Updates',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Filter chips
              Wrap(
                spacing: 8,
                children: List.generate(_filterLabels.length, (i) {
                  final selected = i == _filterIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _filterIndex = i),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? blue : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        _filterLabels[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? blue : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Search bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Event card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/symposium_banner.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 140,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            'Annual tech Symposium 2024',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Institute pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Indian Institute of technology Bombay',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Details rows
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: blue),
                              const SizedBox(width: 6),
                              Text(
                                '15 July 2024 at 4:00pm',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: Colors.green),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Mumbai Convention Center, Mumbai',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.business,
                                  size: 16, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                'Indian Institute of Technology Bombay',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // View Details button
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF8A2BE2),
                                  Color(0xFF4A90E2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // TODO: navigate to details
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegment(String text, int idx) {
    final selected = idx == _campusIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _campusIndex = idx),
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF4A90E2) : Colors.white,
            borderRadius: BorderRadius.horizontal(
              left: idx == 0 ? const Radius.circular(20) : Radius.zero,
              right: idx == 1 ? const Radius.circular(20) : Radius.zero,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}