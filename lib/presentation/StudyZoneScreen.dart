import 'package:flutter/material.dart';

class StudyZoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Study Zone',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Discover and share learning resources',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 16),

              // Balance Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF7E1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Color(0xFFF59E0B),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Your Balance: 145 coins',
                      style: TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search resources...',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              SizedBox(height: 16),

              // Tags Section (Updated with Wrap)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('ALL TAGS', selected: true),
                  _buildTag('DSA'),
                  _buildTag('Aptitude'),
                  _buildTag('Java'),
                  _buildTag('Python'),
                  _buildTag('System Design'),
                  _buildTag('Interview Prep'),
                ],
              ),
              SizedBox(height: 16),

              // Resource Card
              _buildResourceCard(
                title: 'Complete DSA Roadmap 2024',
                description:
                    'Comprehensive guide covering all data structures and algorithms',
                tag: 'DSA',
                rating: 4.8,
                downloads: 1250,
                author: 'Dr. Sarah Chen',
                price: 25,
              ),
              SizedBox(height: 16),

              // Notes Card
              _buildResourceCard(
                title: 'Notes',
                description: 'Additional notes on DSA and algorithms',
                tag: '',
                rating: 0,
                downloads: 0,
                author: '',
                price: 15,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, {bool selected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Color(0xFF6B48FF) : Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Color(0xFFFFFFFF) : Color(0xFF6B48FF),
          fontSize: 12,
          fontFamily: "Inter",
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String description,
    required String tag,
    required double rating,
    required int downloads,
    required String author,
    required int price,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'SR ROADMAP',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 8),
              if (tag.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(color: Color(0xFF6B48FF), fontSize: 12),
                  ),
                ),
                SizedBox(height: 8),
              ],
              Row(
                children: [
                  if (rating > 0) ...[
                    Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(color: Color(0xFF1A1A1A)),
                    ),
                    SizedBox(width: 8),
                  ],
                  if (downloads > 0) ...[
                    Icon(Icons.download, color: Color(0xFF6B7280), size: 16),
                    SizedBox(width: 4),
                    Text(
                      downloads.toString(),
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ],
                ],
              ),
              if (author.isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  'By: $author',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFD1D5DB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFF6B7280),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'PREVIEW',
                            style: TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontFamily: "Inter",
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6B48FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              'BUY',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Inter",
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF10B981),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(price.toString(), style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
