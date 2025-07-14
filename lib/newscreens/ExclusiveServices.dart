import 'package:flutter/material.dart';

class Service {
  final String imageUrl;
  final String userName;
  final String title;
  final String description;

  Service({
    required this.imageUrl,
    required this.userName,
    required this.title,
    required this.description,
  });
}

class ExclusiveServices extends StatefulWidget {
  @override
  _ExclusiveServicesScreenState createState() =>
      _ExclusiveServicesScreenState();
}

class _ExclusiveServicesScreenState extends State<ExclusiveServices> {
  final List<Service> _allServices = [
    Service(
      imageUrl:
      'https://via.placeholder.com/400x150.png?text=Traveling+Banner',
      userName: 'Suraj',
      title: 'A Travel Tricking',
      description:
      'Seen many students struggle to for clear road map for the data science…',
    ),
    Service(
      imageUrl:
      'https://via.placeholder.com/400x150.png?text=Traveling+Banner',
      userName: 'Suraj',
      title: 'A Travel Tricking',
      description:
      'Seen many students struggle to for clear road map for the data science…',
    ),
    // add more items here if you like
  ];

  List<Service> _filteredServices = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _filteredServices = _allServices;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchText = query;
      _filteredServices = _allServices.where((s) {
        return s.title.toLowerCase().contains(query.toLowerCase()) ||
            s.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Widget _buildServiceCard(Service s) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset("assets/images/bannerimg.png",

                height: 192,

                width: 480,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content below image
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/bannerimg.png'),
                      // or NetworkImage(...)
                    ),
                    SizedBox(width: 8),
                    Text(
                      s.userName,
                      style: TextStyle(

                        fontSize: 12,
                            color: Color(0xff222222),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'segeo'),
                      ),

                  ],
                ),

                SizedBox(height: 8),
                // Title
                Text(
                  s.title,
    style: TextStyle(

    fontSize: 14,
    color: Color(0xff222222),
    fontWeight: FontWeight.w700,
    fontFamily: 'segeo'),
    ),

                SizedBox(height: 4),
                // Description
                Text(
                  s.description,


                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
    style: TextStyle(

    fontSize: 12,
    color: Color(0xff666666),
    fontWeight: FontWeight.w400,
    fontFamily: 'segeo'),
    ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar row
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Exclusive Services',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff222222),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'segeo'
                        
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 48), // to balance the back arrow
              ],
            ),

            SizedBox(height: 8),

            // Info text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'To Post your Services mail to rohit@gmail.com',
                style: TextStyle(fontSize: 14,
                    color: Color(0xff666666),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'segeo'),
              ),
            ),

            SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            // List of service cards
            Expanded(
              child: _filteredServices.isEmpty
                  ? Center(child: Text('No services found.', style: TextStyle(fontSize: 14,
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'segeo'),))
                  : ListView.builder(
                itemCount: _filteredServices.length,
                itemBuilder: (_, i) =>
                    _buildServiceCard(_filteredServices[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
