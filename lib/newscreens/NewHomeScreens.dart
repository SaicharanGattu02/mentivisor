import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../bloc/GetBanners/GetBannersCubit.dart';
import '../bloc/GetBanners/GetBannersRepository.dart';
import '../bloc/GetBanners/GetBannersState.dart';
import '../services/remote_data_source.dart';

class HomeScreennew extends StatefulWidget {
  const HomeScreennew({Key? key}) : super(key: key);

  @override
  _HomeScreennewState createState() => _HomeScreennewState();
}

class _HomeScreennewState extends State<HomeScreennew> {
  int _selectedBottomIndex = 0;
  int _selectedToggleIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          Getbannerscubit(BannersImpl(remoteDataSource: RemoteDataSourceImpl()))
            ..getbanners(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hello!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Inter",
                ),
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
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(child: Center(child: Text("Drawer"))),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔄 Dynamic Banner Section
                BlocBuilder<Getbannerscubit, Getbannersstate>(
                  builder: (context, state) {
                    if (state is GetbannersStateLoading) {
                      return Container(
                        height: 180,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is GetbannersStateLoaded) {
                      final banners = state.getbannerModel.data ?? [];
                      if (banners.isEmpty) {
                        return Container(
                          height: 180,
                          alignment: Alignment.center,
                          child: const Text("No banners available"),
                        );
                      }

                      return CarouselSlider.builder(
                        itemCount: banners.length,
                        itemBuilder: (context, index, _) {
                          final imageUrl = banners[index].imgUrl ?? '';
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                        ),
                      );
                    } else if (state is GetbannersStateFailure) {
                      return Container(
                        height: 180,
                        alignment: Alignment.center,
                        child: Text(state.msg),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                const SizedBox(height: 24),

                // 📍 Toggle Buttons (On Campus / Beyond Campus)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xffDBE5FB).withOpacity(0.40),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedToggleIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedToggleIndex == 0
                                  ? const Color(0xFF4076ED).withOpacity(0.10)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Text(
                                'On Campus',
                                style: TextStyle(
                                  color: _selectedToggleIndex == 0
                                      ? const Color(0xff4076ED)
                                      : const Color(0xff666666),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
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
                                  ? const Color(0xFF4076ED).withOpacity(0.10)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Text(
                                'Beyond Campus',
                                style: TextStyle(
                                  color: _selectedToggleIndex == 1
                                      ? const Color(0xff4076ED)
                                      : const Color(0xff666666),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 👨‍🏫 Mentor Heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mentors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add navigation if needed
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(color: Color(0xff4076ED)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 👨‍🏫 Mentors Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          const CircleAvatar(
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
                              color: Color(0xff333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Senior Data Science \nat Google',
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
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                "assets/images/coinsgold.png",
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '25',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _selectedBottomIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _selectedBottomIndex == 0
                    ? primarycolor
                    : const Color(0xff8E8E93),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.school_outlined,
                color: _selectedBottomIndex == 1
                    ? primarycolor
                    : const Color(0xff8E8E93),
              ),
              label: 'Study Zone',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.explore_outlined,
                color: _selectedBottomIndex == 2
                    ? primarycolor
                    : const Color(0xff8E8E93),
              ),
              label: 'ECC',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people_outline,
                color: _selectedBottomIndex == 3
                    ? primarycolor
                    : const Color(0xff8E8E93),
              ),
              label: 'Community',
            ),
          ],
        ),
      ),
    );
  }
}
