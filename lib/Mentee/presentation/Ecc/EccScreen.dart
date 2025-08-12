import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_states.dart';
import 'package:mentivisor/utils/color_constants.dart';
import '../../../services/AuthService.dart';
import '../Widgets/EventCard.dart';
import '../Widgets/FilterButton.dart';

class EccScreen extends StatefulWidget {
  const EccScreen({Key? key}) : super(key: key);

  @override
  _EccScreenState createState() => _EccScreenState();
}

class _EccScreenState extends State<EccScreen> {
  bool _onCampus = true;
  int _selectedFilter = 0;
  String selectedFilter = 'On Campuses';
  final List<String> _filters = ['All', 'Active', 'Upcoming', 'Highlighted'];

  static const Color _blue = Color(0xFF1677FF);
  static const Color _lightBlue = Color(0xFFE4EEFF);

  @override
  void initState() {
    super.initState();
    context.read<ECCCubit>().getECC();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event, Competitions & Challenges',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    height: 1,
                    fontSize: 20,
                    color: Color(0xFF121212),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Participate and Showcase Your Talents',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                FutureBuilder(
                  future: AuthService.isGuest,
                  builder: (context, snapshot) {
                    final isGuest = snapshot.data ?? false;
                    if (!isGuest) {
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          Container(
                            height: 53,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xffDBE5FB).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: FilterButton(
                                    text: 'On Campuses',
                                    isSelected: _onCampus,
                                    onPressed: () {
                                      setState(() {
                                        _onCampus = true;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: FilterButton(
                                    text: 'Beyond Campuses',
                                    isSelected: !_onCampus,
                                    onPressed: () {
                                      setState(() {
                                        _onCampus = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Updates',
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Filter chips
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final selected = i == _selectedFilter;
                      return ChoiceChip(
                        showCheckmark: false,
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        label: Text(
                          _filters[i],
                          style: TextStyle(
                            fontFamily: 'segeo',
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: selected
                                ? Color(0xFF4076ED)
                                : Colors.black54,
                          ),
                        ),
                        selected: selected,
                        onSelected: (_) {
                          setState(() => _selectedFilter = i);
                        },
                        selectedColor: const Color(0xFF4076ED).withOpacity(0.1),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: selected
                              ? const BorderSide(
                                  color: Color(0xFF4076ED),
                                ) // 10% opacity
                              : const BorderSide(color: Colors.transparent),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Search field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                BlocBuilder<ECCCubit, ECCStates>(
                  builder: (context, state) {
                    if (state is ECCLoading) {
                      return Center(
                        child: CircularProgressIndicator(color: primarycolor1),
                      );
                    } else if (state is ECCLoaded || state is ECCLoadingMore) {
                      final ecc_model = (state is ECCLoaded)
                          ? (state as ECCLoaded).eccModel
                          : (state as ECCLoadingMore).eccModel;
                      final ecclist = ecc_model.data?.ecclist;
                      if (ecclist?.length == 0) {
                        return Center(
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Oops !',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                'No Data Found!',
                                style: TextStyle(
                                  color: primarycolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent * 0.9) {
                              if (state is ECCLoaded && state.hasNextPage) {
                                context.read<ECCCubit>().fetchMoreECC();
                              }
                              return false;
                            }
                            return false;
                          },
                          child: CustomScrollView(
                            slivers: [
                              SliverList.separated(
                                itemCount: ecclist?.length ?? 0,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) =>
                                    EventCard(eccList: ecclist![index]),
                              ),
                              if (state is ECCLoadingMore)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text("No Data"));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: AuthService.isGuest,
        builder: (context, snapshot) {
          final isGuest = snapshot.data ?? false;
          return FloatingActionButton(
            onPressed: () {
              if (isGuest) {
                context.push('/auth_landing');
              } else {
                context.push("/addeventscreen");
              }
            },
            backgroundColor: Colors.transparent,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF975CF7),
                    Color(0xFF7A40F2), // Optional darker/lighter variation
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.add, size: 32, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggleButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? _blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: active ? _blue : Colors.transparent),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: active ? _blue : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
