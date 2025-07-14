import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreennew extends StatefulWidget {
  const HomeScreennew({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreennew> {
  int _selectedBottomIndex = 0;
  int _selectedToggleIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hello!',
              style: TextStyle(color: Colors.black, fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Inter"),
            ),
            Text(
              'Vijay',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Inter",
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Handle notification tap
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profileimg.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Vijay',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Profile screen
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/walletimg.png',
                height: 24,
                width: 24,
              ),
              title: const Text('Wallet', style: TextStyle(color: Color(0xff333333))),
              trailing: const Text('120', style: TextStyle(color: Color(0xff333333))),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Wallet
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/Downloadsimpleimg.png',
                height: 24,
                width: 24,
              ),
              title: Text('Downloads'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Downloads screen
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/Pencilrulerimg.png',
                height: 24,
                width: 24,
              ),
              title: Text('Productivity tools'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Productivity Tools screen
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/Videoconference.png',
                height: 24,
                width: 24,
              ),
              title: Text('Session Completed'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Session Completed screen
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/upcommingsessions.png',
                height: 24,
                width: 24,
              ),
              title: Text('Upcoming Sessions'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Upcoming Sessions screen
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/Videoconference.png',
                height: 24,
                width: 24,
              ),
              title: Text('Exclusive Services'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Exclusive Services screen
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/coinsgold.png',
                height: 24,
                width: 24,
              ),
              title: Text('Info'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Info screen
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/coinsgold.png',
                height: 24,
                width: 24,
              ),
              title: Text('Become Mentor'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Become Mentor screen
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/home_banner_Img.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Toggle Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedToggleIndex = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedToggleIndex == 0
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'On Campus',
                              style: TextStyle(
                                color: _selectedToggleIndex == 0
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedToggleIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedToggleIndex == 1
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Beyond Campus',
                              style: TextStyle(
                                color: _selectedToggleIndex == 1
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Mentors Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mentors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AllMentorsScreen()),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Mentor Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(
                              'assets/images/profileimg.png',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Vinay',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff333333)
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Senior Data Science \n at Google',
                            style: TextStyle(
                              color: Color(0xff555555),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '4.9 (27)',
                                style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 8),
                              const Image(
                                image: AssetImage("assets/images/coinsgold.png"),
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '25',
                                style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedBottomIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Study Zone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'ECC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

class AllMentorsScreen extends StatefulWidget {
  @override
  _AllMentorsScreenState createState() => _AllMentorsScreenState();
}

class _AllMentorsScreenState extends State<AllMentorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> mentors = [
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
    {'name': 'Vinay', 'title': 'Senior Data Science at Google', 'rating': '4.9 (27)', 'coins': '25'},
  ];

  List<Map<String, dynamic>> filteredMentors = [];

  @override
  void initState() {
    super.initState();
    filteredMentors = mentors;
    _searchController.addListener(_filterMentors);
  }

  void _filterMentors() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredMentors = mentors.where((mentor) {
        return mentor['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'All Mentors',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Inter",
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search your mentor',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredMentors.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage('assets/images/profileimg.png'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filteredMentors[index]['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff333333)
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            filteredMentors[index]['title'],
                            style: TextStyle(
                              color: Color(0xff555555),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                filteredMentors[index]['rating'],
                                style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 8),
                              const Image(
                                image: AssetImage("assets/images/coinsgold.png"),
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                filteredMentors[index]['coins'],
                                style: TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}