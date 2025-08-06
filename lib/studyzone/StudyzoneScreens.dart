import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudyZoneScreen extends StatefulWidget {
  const StudyZoneScreen({Key? key}) : super(key: key);

  @override
  _StudyZoneScreenState createState() => _StudyZoneScreenState();
}

class _StudyZoneScreenState extends State<StudyZoneScreen> {
  bool _onCampus = true;
  String _searchText = '';
  int _selectedTagIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  final List<String> _campusTags = [
    'All Tags',
    'DSA',
    'Aptitude',
    'Java',
    'Python',
    'System',
  ];
  // sample data
  final List<Map<String, String>> _resources = List.generate(5, (i) => {
    'image': 'https://via.placeholder.com/120.png?text=DSA',
    'title': 'Complete DSA Roadmap 2024',
    'subtitle':
    'Compressive Guide Covering all data Structures and algorithms',
    'tag': ['DSA', 'Aptitude', 'Java', 'Python', 'System'][i % 5],
  });

  // Gradient colors for Download button & FAB
  static const Color grad1 = Color(0xFFA258F7);
  static const Color grad2 = Color(0xFF726CF7);
  static const Color grad3 = Color(0xFF4280F6);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddResource() {
    // handle FAB tap
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _resources.where((r) {
      final tagMatch =
          _selectedTagIndex == 0 || r['tag'] == _campusTags[_selectedTagIndex];
      final searchMatch = _searchText.isEmpty ||
          r['title']!.toLowerCase().contains(_searchText.toLowerCase());
      return tagMatch && searchMatch;
    }).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Study Zone',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF121212),
            fontFamily: 'Segoe',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: const Text(
            'Download and share your study resources',
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

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontFamily: 'Segoe'),
                decoration: InputDecoration(
                  hintText: 'Search your Topics',
                  hintStyle: const TextStyle(fontFamily: 'Segoe'),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Tag chips
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _campusTags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final sel = i == _selectedTagIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFEDEBFF) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: sel ? Colors.transparent : const Color(0xFFE0E0E0),
                    ),
                    boxShadow: sel
                        ? [
                      const BoxShadow(
                        color: Color(0xFFDDDFFF),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ]
                        : null,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTagIndex = i),
                    child: Center(
                      child: Text(
                        _campusTags[i],
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: sel
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Resource list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, idx) {
                final r = filtered[idx];
                return _ResourceCard(data: r);
              },
            ),
          ),
        ],
      ),

      // Floating “+” button
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
          onPressed: _onAddResource,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 32),
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
            color: active ? const Color(0xFF4076ED).withOpacity(0.1) : Colors.transparent,
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

class _ResourceCard extends StatelessWidget {
  final Map<String, String> data;
  const _ResourceCard({Key? key, required this.data}) : super(key: key);

  static const Color grad1 = Color(0xFFA258F7);
  static const Color grad2 = Color(0xFF726CF7);
  static const Color grad3 = Color(0xFF4280F6);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
             "images/download.jpg",
              height: 144,
              width: 144,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 144,
                width: 144,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text & buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title']!,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['subtitle']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEBFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      data['tag']!,
                      style: const TextStyle(
                        fontFamily: 'segeo',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF7F00FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [

                      // View button
                      SizedBox( height: 36,
                        width: 100,
                        child: OutlinedButton(

                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1.5,
                              color: Color(0xFF7F00FF),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF7F00FF),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                      // Download button
                      SizedBox(
                        height: 36,
                        width: 100,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [grad1, grad2, grad3],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Center(
                              child: Text(
                                'Download',
                                style: TextStyle(
                                  fontFamily: 'segeo',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}