import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Communityscreen extends StatefulWidget {
  const Communityscreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<Communityscreen> {
  bool _onCampus = true;
  int _selectedTabIndex = 0;

  final List<String> _mainTabs = ['On Campus', 'Beyond Campus'];
  final List<String> _subTabs = ['All', 'Recent', 'Trending', 'Highlighted'];

  // Sample data based on the image
  final List<Map<String, String>> _posts = List.generate(
    5,
    (i) => {
      'image': 'assets/images/communityimage.png', // Replace with actual path
      'author': 'Suraj',
      'title': 'A Complete Guide for the Data Science Road Map',
      'subtitle':
          'Seen many students struggle to for clear road map for science i made it simple and clear',
      'likes': '100',
      'comments': '100',
      'highlighted': i == 1 || i == 3 ? 'true' : 'false', // Highlighted posts
    },
  );

  // Gradient colors for FAB
  static const Color grad1 = Color(0xFFA258F7);
  static const Color grad2 = Color(0xFF726CF7);
  static const Color grad3 = Color(0xFF4280F6);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onAddPost() {
    // Handle Add button tap
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _posts; // No filtering for now, match image
    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF), // Match image background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Community',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF121212),
            fontFamily: 'Segoe',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: const Text(
            'Connect and Collaborate with Peers',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontFamily: 'Segoe',
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // On Campus / Beyond Campus toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8EBF7),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildToggle('On Campus', _onCampus, () {
                    setState(() => _onCampus = true);
                  }),
                  const SizedBox(width: 8),
                  _buildToggle('Beyond Campus', !_onCampus, () {
                    setState(() => _onCampus = false);
                  }),
                ],
              ),
            ),
          ),

          // Posts section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Posts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121212),
                    fontFamily: 'Segoe',
                  ),
                ),

                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(
                            0xFF8A56AC,
                          ), // Solid darker purple for icon
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD1A9F0), // Lighter purple start
                              Color(0xFFE6C4F5), // Even lighter purple end
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontFamily: 'Segoe',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sub Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _subTabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final sel = i == _selectedTabIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFFB9DFFF) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: sel
                            ? Colors.transparent
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = i),
                      child: Center(
                        child: Text(
                          _subTabs[i],
                          style: TextStyle(
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: sel
                                ? const Color(0xFF2196F3)
                                : const Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Post list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, idx) {
                final p = filtered[idx];
                return _PostCard(data: p);
              },
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [grad1, grad2, grad3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.chat_bubble, size: 28),
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF4076ED).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: active ? const Color(0xFF4076ED) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: active ? const Color(0xFF4076ED) : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, String> data;
  const _PostCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                data['image']!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage(
                          'assets/images/profileimg.png',
                        ), // Replace with actual path
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data['author']!,
                        style: const TextStyle(
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['title']!,
                    style: const TextStyle(
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['subtitle']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up_alt_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        data['likes']!,
                        style: const TextStyle(fontFamily: 'Segoe'),
                      ),
                      const SizedBox(width: 24),
                      const Icon(Icons.comment_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        data['comments']!,
                        style: const TextStyle(fontFamily: 'Segoe'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (data['highlighted'] == 'true')
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[400],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Highlighted',
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontSize: 12,
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
      ),
    );
  }
}
