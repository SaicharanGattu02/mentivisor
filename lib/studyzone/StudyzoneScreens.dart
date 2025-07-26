import 'package:flutter/material.dart';

class StudyZonemainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<StudyZonemainScreen> {
  int _currentIndex = 1;
  final _pages = [
    Scaffold(body: Center(child: Text('Home'))),
    StudyZoneScreen(),
    Scaffold(body: Center(child: Text('ECC'))),
    Scaffold(body: Center(child: Text('Community'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Study Zone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            label: 'ECC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

class StudyZoneScreen extends StatefulWidget {
  @override
  _StudyZoneScreenState createState() => _StudyZoneScreenState();
}

class _StudyZoneScreenState extends State<StudyZoneScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<String> _campusTags = [
    'All Tags',
    'DSA',
    'Aptitude',
    'Java',
    'Python',
    'System',
  ];
  final List<String> _beyondTags = [
    'All Tags',
    'ML',
    'AI',
    'Flutter',
    'DevOps',
  ];

  int _campusTagIndex = 0;
  int _beyondTagIndex = 0;

  // Dummy resources
  final List<Map<String, String>> _campusResources = List.generate(5,
    (i) => {
      'image': 'https://via.placeholder.com/120.png?text=Campus',
      'title': 'Campus Resource #\$i',
      'subtitle': 'Description for campus resource #\$i',
      'tag': ['DSA', 'Aptitude', 'Java', 'Python', 'System'][i % 5],
    },
  );
  final List<Map<String, String>> _beyondResources = List.generate(
    4,
    (i) => {
      'image': 'https://via.placeholder.com/120.png?text=Beyond',
      'title': 'Beyond Resource #\$i',
      'subtitle': 'Description for beyond resource #\$i',
      'tag': ['ML', 'AI', 'Flutter', 'DevOps'][i % 4],
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(

                  'Study Zone',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),

                ),
                SizedBox(height: 4),

                Text(
                  'Download and share your study resources',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),

          // Top tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEDEBFF), Color(0xFFF0F0FF)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Color(0xFF7F00FF),
                unselectedLabelColor: Colors.black54,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'On Campus'),
                  Tab(text: 'Beyond Campus'),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for any thing',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),

                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Tags & content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(
                  tags: _campusTags,
                  selectedIndex: _campusTagIndex,
                  onTagTap: (i) => setState(() => _campusTagIndex = i),
                  resources: _campusResources,
                ),
                _buildTabContent(
                  tags: _beyondTags,
                  selectedIndex: _beyondTagIndex,
                  onTagTap: (i) => setState(() => _beyondTagIndex = i),
                  resources: _beyondResources,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({
    required List<String> tags,
    required int selectedIndex,
    required void Function(int) onTagTap,
    required List<Map<String, String>> resources,
  }) {
    // filter by tag
    final filtered = resources.where((r) {
      final tagMatch = selectedIndex == 0 || r['tag'] == tags[selectedIndex];
      final searchMatch =
          _searchText.isEmpty ||
          r['title']!.toLowerCase().contains(_searchText.toLowerCase()) ||
          r['subtitle']!.toLowerCase().contains(_searchText.toLowerCase());
      return tagMatch && searchMatch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: tags.length,
            separatorBuilder: (_, __) => SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final selected = i == selectedIndex;
              return ChoiceChip(
                label: Text(tags[i]),
                selected: selected,
                onSelected: (_) => onTagTap(i),
                backgroundColor: Colors.white,
                selectedColor: Color(0xFFEDEBFF),
                labelStyle: TextStyle(
                  color: selected ? Color(0xFF7F00FF) : Colors.black87,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 16),

        // Resources list
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (ctx, idx) {
              final r = filtered[idx];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.asset('assets/images/download.jpg',
                          height: 144,
                          width: 144,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),


                    SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r['title']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff222222),

                                fontWeight: FontWeight.w700,
                                fontFamily: 'segeo',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              r['subtitle']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'segeo',
                                fontSize: 11,
                                color: Color(0xff666666),
                              ),
                            ),
                            SizedBox(height:8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFEDEBFF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                r['tag']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7F00FF),
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            Row(
                              children: [
                                // Container(
                                //   padding: EdgeInsets.symmetric(
                                //     horizontal: 8,
                                //     vertical: 4,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: Color(0xFFEDEBFF),
                                //     borderRadius: BorderRadius.circular(12),
                                //   ),
                                //   child: Text(
                                //     r['tag']!,
                                //     style: TextStyle(
                                //       fontSize: 12,
                                //       color: Color(0xFF7F00FF),
                                //     ),
                                //   ),
                                // ),

                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF7F00FF), // Starting color
                                          Color(0xFF4280F6), // Ending color
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: Color(0xFF4280F6)),
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: Text(
                                        'View',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 36,
                                    width: 107,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFA258F7),
                                          Color(0xFF726CF7),
                                          Color(0xFF4280F6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: Text('Download',style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'segeo',
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
