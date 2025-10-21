import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServiceList_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_state.dart';

import '../../Components/Shimmers.dart';
import '../../utils/color_constants.dart';
import '../../utils/media_query_helper.dart';
import '../../utils/spinkittsLoader.dart';

class ExclusiveServices extends StatefulWidget {
  @override
  State<ExclusiveServices> createState() => _ExclusiveServicesScreenState();
}

class _ExclusiveServicesScreenState extends State<ExclusiveServices> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ExclusiveservicelistCubit>().getExclusiveServiceList("");
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: CustomAppBar1(title: "Exclusive Services", actions: []),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFF5F6FF), Color(0xffEFF6FF)],
          ),
        ),
        child: Column(
          children: [
            Text(
              "To Post your Services mail to rohit@gmail.com",
              style: TextStyle(
                fontFamily: 'segeo',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff666666),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: TextField(
                controller: searchController,
                cursorColor: primarycolor,
                onChanged: (query) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    context
                        .read<ExclusiveservicelistCubit>()
                        .getExclusiveServiceList(query);
                  });
                },
                style: TextStyle(fontFamily: "Poppins", fontSize: 15),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none, // removes default border line
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                  hoverColor: Colors.white,
                  hintText: "Search by Service Name",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff666666),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.only(right: 33, left: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            BlocBuilder<ExclusiveservicelistCubit, ExclusiveserviceslistState>(
              builder: (context, state) {
                if (state is ExclusiveserviceStateLoading) {
                  return Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _getCrossAxisCount(context),
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 0,
                                childAspectRatio: _getChildAspectRatio(context),
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => const ServiceCardShimmer(),
                            childCount: 5, // shimmer count
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is ExclusiveserviceStateFailure) {
                  return Center(child: Text(state.msg ?? 'Failed to load'));
                } else if (state is! ExclusiveserviceStateLoaded) {
                  return const Center(child: Text('No data available'));
                } else {
                  final list = state.exclusiveServicesModel.data?.data ?? [];
                  return Expanded(
                    child: CustomScrollView(
                      slivers: [
                        if (list.isEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 48),
                              child: Center(
                                child: Column(
                                  spacing: 10,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/nodata/no_data.png",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      'No Exclusive Service Found!',
                                      style: TextStyle(
                                        color: primarycolor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _getCrossAxisCount(
                                    context,
                                  ), // 👈 1 on mobile, 2 on tab
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 0,
                                  childAspectRatio: _getChildAspectRatio(
                                    context,
                                  ), // 👈 dynamic ratio
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final serviceList = list[index];
                              return _ServiceCard(
                                exclusiveServiceImageUrl:
                                    serviceList.exclusiveService ?? '',
                                imageUrl: serviceList.imageUrl ?? '',
                                title: serviceList.name ?? '',
                                description: serviceList.description ?? '',
                                onTap: () {
                                  context.push(
                                    '/service_details?id=${serviceList.id}&title=${serviceList.name ?? ''}',
                                  );
                                },
                              );
                            }, childCount: list.length),
                          ),
                        if (state is ExclusiveserviceStateLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.6,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // Mobile
    } else if (width < 900) {
      return 2; // Tablet
    } else {
      return 3; // Larger screens
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // base ratio derived from screen proportions
    double baseRatio = width / height;

    if (width < 600) {
      // Mobile – taller cards
      return baseRatio * 3.15;
    } else if (width > 600) {
      // Tablet – more square
      return baseRatio * 2.2;
    } else {
      // Desktop or large tablet
      return baseRatio * 2.2;
    }
  }
}

class _ServiceCard extends StatelessWidget {
  final String exclusiveServiceImageUrl;
  final String imageUrl;
  // final String authorName;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.exclusiveServiceImageUrl,
    required this.imageUrl,
    // required this.authorName,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9DEE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: exclusiveServiceImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: exclusiveServiceImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (c, _) => const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.8,
                                ),
                              ),
                            ),
                            errorWidget: (c, _, __) => const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
              // const SizedBox(height: 12),
              // Row(
              //   children: [
              //     CachedNetworkImage(
              //       imageUrl: imageUrl,
              //       imageBuilder: (context, imageProvider) => CircleAvatar(
              //         radius: 12,
              //         backgroundImage: imageProvider,
              //       ),
              //       placeholder: (context, url) => CircleAvatar(
              //         radius: 12,
              //         backgroundColor: Colors.grey,
              //         child: SizedBox(
              //           width: 12,
              //           height: 12,
              //           child: Center(child: spinkits.getSpinningLinespinkit()),
              //         ),
              //       ),
              //       errorWidget: (context, url, error) => const CircleAvatar(
              //         radius: 12,
              //         backgroundImage: AssetImage("assets/images/profile.png"),
              //       ),
              //     ),
              //     const SizedBox(width: 8),
              //     Text(
              //       authorName,
              //       style: const TextStyle(
              //         fontFamily: 'segeo',
              //         fontSize: 12,
              //         color: Color(0xFF222222),
              //         fontWeight: FontWeight.w400,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 12),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 14,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 12,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCardShimmer extends StatelessWidget {
  const ServiceCardShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Image section shimmer
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD9DEE7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: shimmerContainer(double.infinity, 140, context),
            ),
          ),
          const SizedBox(height: 6),
          // 🔹 Title shimmer
          shimmerText(150, 14, context),
          const SizedBox(height: 6),
          // 🔹 Description shimmer (2 lines)
          shimmerText(double.infinity, 12, context),
          const SizedBox(height: 4),
          shimmerText(200, 12, context),
        ],
      ),
    );
  }
}
