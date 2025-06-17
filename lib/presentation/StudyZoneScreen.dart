import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StudyZoneScreen extends StatefulWidget {
  @override
  State<StudyZoneScreen> createState() => _StudyZoneScreenState();
}
class Roadmap {
  final String imagePath;
  final String title;
  final String description;
  final String tag;
  final double rating;
  final int downloads;
  final String author;
  final int price;

  Roadmap({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.tag,
    required this.rating,
    required this.downloads,
    required this.author,
    required this.price,
  });
}

class _StudyZoneScreenState extends State<StudyZoneScreen> {
  final List<String> tags = [
    "ALL TAGS",
    "DSA",
    "APTITUDE",
    "JAVA",
    "PYTHON",
    "SYSTEM DESIGN",
    "INTERVIEW PREP",
  ];

  String selectedTag = "ALL TAGS";

  // Sample list of roadmaps for looping
  final List<Roadmap> roadmaps = [
    Roadmap(
      imagePath: 'assets/images/download.jpg',
      title: 'Complete DSA Roadmap 2024',
      description:
          'Comprehensive guide covering all data structures and algorithms',
      tag: 'DSA',
      rating: 4.8,
      downloads: 1250,
      author: 'Dr. Sarah Chen',
      price: 25,
    ),
    Roadmap(
      imagePath: 'assets/images/download.jpg',
      title: 'System Design Mastery 2024',
      description: 'In-depth guide to system design concepts and patterns',
      tag: 'SYSTEM DESIGN',
      rating: 4.5,
      downloads: 890,
      author: 'Prof. John Doe',
      price: 30,
    ),
    Roadmap(
      imagePath: 'assets/images/download.jpg',
      title: 'Java Programming Roadmap 2024',
      description: 'Complete roadmap for mastering Java programming',
      tag: 'JAVA',
      rating: 4.7,
      downloads: 1020,
      author: 'Dr. Emily Brown',
      price: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff6faff),
              Color(0xffe0f2fe),
            ], // Replace with your desired gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 40,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(width: 1, color: Color(0xffe2e8f0)),
                  padding: EdgeInsets
                      .zero, // Ensures no extra padding disturbs centering
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            // Title and Subtitle
            Text(
              "Study Zone",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2A44),
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Discover and share learning resources",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 16),

            // Balance Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffef9c3),
                    Color(0xffffedd5),
                  ], // Replace with your desired gradient
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg_icons/coins.svg",
                    color: Color(0xFFD97706),
                    height: 20,
                    width: 20,
                  ),
                  Text(
                    "Your Balance: 145 coins",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF6B7280)),
                  SizedBox(width: 8),
                  Text(
                    "Search resources...",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                final bool isSelected = selectedTag == tag;
                return ChoiceChip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF374151),
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedTag = tag;
                    });
                  },
                  showCheckmark: false,
                  selectedColor: const Color(0xFF9333EA),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF9333EA)
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Roadmap Card
            // Looping Roadmap Cards
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: roadmaps.length,
                itemBuilder: (context, index) {
                  final roadmap = roadmaps[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: Image.asset(
                                  roadmap.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Chip(
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg_icons/coins.svg",
                                        color: Colors.white,
                                        height: 15,
                                        width: 15,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        roadmap.price.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Color(0xFF10B981),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 2,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Chip(
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg_icons/roadmap.svg",
                                        color: Colors.black,
                                        height: 15,
                                        width: 15,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "ROADMAP",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  roadmap.title,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A2A44),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  roadmap.description,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        roadmap.tag,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                      backgroundColor: Color(0xFFE5E7EB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(36),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFFBBF24),
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      roadmap.rating.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(
                                      Icons.download,
                                      color: Color(0xFF6B7280),
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      roadmap.downloads.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "By ${roadmap.author}",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Color(0xFFD1D5DB),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "PREVIEW",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF7C3AED),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg_icons/coins.svg",
                                              color: Colors.white,
                                              height: 15,
                                              width: 15,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "BUY",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
