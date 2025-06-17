import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> mentors = [
    {
      'name': 'Dr. Priya Sharma',
      'title': 'Data Science Lead at Netflix',
      'rating': 4.9,
      'reviews': 156,
      'coins': 28,
      'tags': ['Data Analytics', 'ML Engineering'],
      'timing': 'Next Week',
      'available': false,
      'avatar': 'assets/images/priya.png',
    },
  ];
  String? _selectDomain;
  String? _selectStars;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.orange, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
              ),
              onPressed: () {},
              child: Row(
                spacing: 4,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.deepPurple,
                  ),
                  Text(
                    '150 coins',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, Mentee!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text(
                'Session Booking',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  fontFamily: "Inter",
                ),
              ),
              onTap: () {
                context.push("/book_sessions_screen");
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Study Zone',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  fontFamily: "Inter",
                ),
              ),
              onTap: () {
                context.push("/study_zone");
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red,fontFamily: "Inter")),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xfffaf5ff), Color(0xffeff6ff), Color(0xffe0e7ff)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              _buildStatCard('Sessions Completed', '8', [
                Color(0xFF8B5CF6),
                Color(0xFF7C3AED),
              ], Icons.emoji_events),
              _buildStatCard('Upcoming Sessions', '2', [
                Color(0xFF3B82F6), // blue-500
                Color(0xFF2563EB), // blue-600
              ], Icons.calendar_today),
              _buildStatCard('Goals Achieved', '5', [
                Color(0xFF22C55E),
                Color(0xFF16A34A),
              ], Icons.star_border),
              _buildStatCard('Coin Balance', '150', [
                Color(0xFFF97316),
                Color(0xFFEA580C),
              ], Icons.monetization_on),
              SizedBox(height: 16),
              Container(
                width: w,
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Sessions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ListView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          width: w,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xfffaf5ff),
                                Color(0xffeff6ff),
                                Color(0xffe0e7ff),
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: w * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Career Growth Strategy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        color: Color(0xff111827),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'with Dr. Sarah Chen',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        color: Color(0xff4B5563),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Today at 4:00 PM • \nVideo Call',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  minimumSize: const Size(0, 36),
                                ),
                                child: const Text(
                                  'Join Session',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF020817),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              Container(
                width: w,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      height: 40,
                      child: Stack(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 40,
                              ),
                              hintText:
                                  'Search mentors by name or expertise...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                              ), // placeholder:text-muted-foreground
                              filled: true,
                              fillColor: Colors.white,

                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFCBD5E1),
                                ), // border-input
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // rounded-md
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFCBD5E1),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFCBD5E1),
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            style: const TextStyle(fontSize: 16), // text-base
                          ),
                          const Positioned(
                            left: 12,
                            top: 12,
                            child: Center(
                              child: Icon(
                                Icons.search,
                                size: 16, // w-4 h-4
                                color: Colors.grey, // text-gray-400
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select Domain',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items:
                            [
                                  'All Domains',
                                  'Technology',
                                  'Product Management',
                                  'Data Science',
                                  'Business',
                                ]
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        color: Colors
                                            .black, // Changed from white to black for visibility
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        value: _selectDomain,
                        onChanged: (String? value) {
                          setState(() {
                            _selectDomain = value!;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Color(0xFFCBD5E1),
                              width: 1,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          iconSize: 26,
                          iconEnabledColor: Colors
                              .grey
                              .shade700, // Changed for better visibility
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>((
                                Set<MaterialState> states,
                              ) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors
                                      .grey
                                      .shade200; // light hover effect
                                }
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.grey.shade300; // pressed effect
                                }
                                return null;
                              }),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select Ratings',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items:
                            [
                                  'All Ratings',
                                  '4.5+ Stars',
                                  '4.0+ Stars',
                                  '3.5+ Stars',
                                ]
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        value: _selectStars,
                        onChanged: (String? value) {
                          setState(() {
                            _selectStars = value!;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Color(0xFFCBD5E1),
                              width: 1,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          iconSize: 26,
                          iconEnabledColor: Colors
                              .grey
                              .shade700, // Changed for better visibility
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>((
                                Set<MaterialState> states,
                              ) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors
                                      .grey
                                      .shade200; // light hover effect
                                }
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.grey.shade300; // pressed effect
                                }
                                return null;
                              }),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    ListView.builder(
                      itemCount: mentors.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final mentor = mentors[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      mentor['avatar'],
                                    ), // Use NetworkImage if dynamic
                                    radius: 24,
                                    backgroundColor: Colors.grey.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mentor['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          mentor['title'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(
                                    ' ${mentor['rating']} (${mentor['reviews']})',
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(' ${mentor['coins']}'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: mentor['tags']
                                    .map<Widget>(
                                      (tag) => Chip(
                                        label: Text(tag),
                                        backgroundColor: Colors.purple[50],
                                        labelStyle: TextStyle(
                                          color: Colors.purple,
                                        ),
                                        side: BorderSide.none,
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    mentor['timing'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('View Profile'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: mentor['available']
                                        ? () {}
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                    child: const Text('Book'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    List<Color> gradientColors,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Icon(icon, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}
