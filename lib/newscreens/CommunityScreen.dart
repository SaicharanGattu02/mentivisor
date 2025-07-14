import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AddPostScreen.dart';
import 'ChartScreen.dart';
import 'PostDetailScreen.dart';

class Communityscreen extends StatelessWidget {
  const Communityscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Community',
      theme: ThemeData(
        primaryColor: const Color(0xFFE0F0FF),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const CommunityHome(),
        '/detail': (_) => const PostDetailScreen(),
        '/add': (_) => const AddPostScreen(),
        '/chart': (_) => const ChartScreen(),
      },
    );
  }
}

class CommunityHome extends StatefulWidget {
  const CommunityHome({Key? key}) : super(key: key);

  @override
  _CommunityHomeState createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _subTabController;

  final List<String> mainTabs = ['On Campus', 'Beyond Campus'];
  final List<String> subTabs = ['All', 'Recent', 'Trending', 'Highlighted'];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: mainTabs.length, vsync: this);
    _subTabController = TabController(length: subTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _subTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Community',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Connect and Collaborate with Peers',
                style: TextStyle(
                    color: Colors.grey, fontSize: 14, height: 1.3)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _mainTabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFB9DFFF)),
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black,
              tabs: mainTabs
                  .map((t) => Tab(text: t))
                  .toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TabBar(
                    controller: _subTabController,
                    isScrollable: true,
                    indicatorColor: const Color(0xFF2196F3),
                    labelColor: const Color(0xFF2196F3),
                    unselectedLabelColor: Colors.grey,
                    tabs: subTabs.map((t) => Tab(text: t)).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/add'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A56AC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _subTabController,
              children: subTabs.map((_) => _postList()).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF8A56AC),
        child: const Icon(Icons.chat_bubble, size: 28),
      ),
    );
  }

  Widget _postList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5,
      itemBuilder: (_, i) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/detail'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12)),
                child: Image.asset(
                  "images/communityimage.png",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage:
                      NetworkImage('assets/images/communityimage.png',),
                    ),
                    const SizedBox(width: 8),
                    const Text('Suraj',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: const Text(
                  'A Complete Guide for the Data Science Road Map',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: const Text(
                  'Seen many students struggle to paindi and clear simple and clear',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: const [
                    Icon(Icons.thumb_up_alt_outlined, size: 18),
                    SizedBox(width: 6),
                    Text('100'),
                    SizedBox(width: 24),
                    Icon(Icons.comment_outlined, size: 18),
                    SizedBox(width: 6),
                    Text('100'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
