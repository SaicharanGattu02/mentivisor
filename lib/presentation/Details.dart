import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfffaf5ff),
              Color(0xffeff6ff),
              Color(0xffe0e7ff),
            ], // Replace with your desired gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                SizedBox(
                  width: 50,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xffe2e8f0),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                SizedBox(height: 16),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/download.jpg',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Roadmap",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _cardContainer(
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About This Resource",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Color(0xff020817),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Comprehensive guide covering all data structures and algorithms",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff4B5563),
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              "Preview Content:",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Color(0xff020817),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Learn 50+ algorithms with detailed explanations...",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                color: Color(0xff4B5563),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                _cardContainer(
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "What You'll Learn",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Color(0xff020817),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPoint(1, "Introduction to core concepts"),
                      _buildPoint(2, "Practical examples and exercises"),
                      _buildPoint(3, "Advanced techniques and best practices"),
                      _buildPoint(4, "Real-world project implementation"),
                      _buildPoint(5, "Tips for technical interviews"),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Course Info
                _cardContainer(
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Complete DSA Roadmap 2024",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          color: Color(0xff020817),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      _infoRow("Price:", "25 coins"),
                      _infoRow("Rating:", "⭐ 4.8"),
                      _infoRow("Downloads:", "1250"),
                      _infoRow("Category:", "DSA"),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Author
                _cardContainer(
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About the Author",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'segeo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xff9333EA),
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Dr. Sarah Chen",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'segeo',
                                      fontSize: 16,
                                      color: Color(0xff111827),
                                    ),
                                  ),
                                  Text(
                                    "Verified Mentor",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'segeo',
                                      fontSize: 14,
                                      color: Color(0xff6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                
                          SizedBox(height: 4),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.star_border,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              Text(
                                "4.8 average rating",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                  color: Color(0xff4B5563),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.download_rounded,
                                color: Colors.grey[500],
                                size: 16,
                              ),
                              Text(
                                "15,000+ downloads",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                  color: Color(0xff4B5563),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey[500],
                                size: 16,
                              ),
                              Text(
                                "Member since 2022",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'segeo',
                                  fontSize: 14,
                                  color: Color(0xff4B5563),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: w,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff9333EA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                
                    label: Text(
                      'Purchase for 25 coins',
                      style: TextStyle(
                        color: Color(0xfff8fafc),
                        fontSize: 16,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  width: w,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                
                    label: const Text(
                      'Preview Content',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg_icons/coins.svg',
                              fit: BoxFit.cover,
                              width: 20,
                              height: 20,
                              color: Color(0xff854D0E),
                            ),
                            Text(
                              "Your Balance",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'segeo',
                                color: Color(0xff854D0E),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "145 coins",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            fontFamily: 'segeo',
                            color: Color(0xff854D0E),
                          ),
                        ),
                      ],
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

  Widget _buildPoint(int index, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF8B5CF6),
            child: Text(
              "$index",
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'segeo',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'segeo',
                color: Color(0xff374151),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardContainer({required double width, required Widget child}) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _infoRow extends StatelessWidget {
  final String label;
  final String value;
  const _infoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'segeo',
              fontSize: 16,
              color: Color(0xff4B5563),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'segeo',
                  fontSize: 16,
                  color: Color(0xff020817),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
