import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mentivisor/Mentor/presentation/widgets/SessionCard.dart';
import '../../utils/color_constants.dart';
import '../../utils/media_query_helper.dart';

class MentorHomeScreen extends StatefulWidget {
  const MentorHomeScreen({Key? key}) : super(key: key);

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<String> bannerData = [
    'assets/images/buycoinsimg.png',
    'assets/images/buycoinsimg.png',
    'assets/images/buycoinsimg.png',
    'assets/images/buycoinsimg.png',
  ];

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xFFEFF6FF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: SizeConfig.screenHeight * 0.2,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                pauseAutoPlayOnTouch: true,
                scrollDirection: Axis.horizontal,
                aspectRatio: 16 / 9,
                onPageChanged: (i, _) => _currentIndex.value = i,
              ),
              items: bannerData.map((assetPath) {
                return InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: Colors.grey.shade200,
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, currentIndex, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bannerData.length, (index) {
                    final isFirst = index == 0;
                    final isLast = index == bannerData.length - 1;
                    final isNear = (index - currentIndex).abs() <= 1;

                    if (!isFirst && !isLast && !isNear) {
                      return const SizedBox.shrink();
                    }
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: SizeConfig.screenHeight * 0.008,
                      width: currentIndex == index
                          ? SizeConfig.screenWidth * 0.05
                          : SizeConfig.screenWidth * 0.014,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? primarycolor
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Upcoming Session',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'segeo',
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => SessionCard(
                        status: 'Upcoming',
                        sessionDate: '5th Jun 2025',
                        sessionTime: '45 Minutes to go',
                        sessionName: 'G-Meet with Suresh from SVG Collage',
                        sessionImage:
                            'assets/images/image.png', // Image for upcoming sessions
                        sessionTopics:
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        reason:
                            'Lorem Ipsum has been the industry standard for type.',
                        buttonText: 'Message from Suresh',
                        buttonIcon: 'assets/icons/chaticon.png',
                        remainingTime:
                            '45 Minutes to go', // Time remaining for upcoming session
                      ),
                      childCount: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '5th Jun 2025',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'segeo',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'G-Meet with Ramesh',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'segeo',
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/image.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4076ED).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '2 Jun 2025 at 5:00 PM',
                style: TextStyle(
                  color: Color(0xFF4076ED),
                  fontSize: 12,
                  fontFamily: 'segeo',
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Session Topics',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'segeo',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the.....',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'segeo',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF4E9FF),
                          Color(0xFFE1E4FF),
                          Color(0xFFE2EEFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.message, size: 16),
                      label: Text(
                        'Message from Ramesh',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'segeo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      backgroundColor: const Color(0xFFF5F5F5),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontFamily: 'segeo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
