import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServiceList_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_state.dart';

import '../../utils/color_constants.dart';

class ExclusiveServices extends StatefulWidget {
  @override
  _ExclusiveServicesScreenState createState() =>
      _ExclusiveServicesScreenState();
}

class _ExclusiveServicesScreenState extends State<ExclusiveServices> {
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    context.read<ExclusiveservicelistCubit>().getExclusiveServiceList("");
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5FA),
      appBar: CustomAppBar1(title: "Exclusive Services", actions: []),
      body: Column(
        children: [
          const SizedBox(height: 12),
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
                hoverColor: Colors.white,
                hintText: 'Search for any thing',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xff666666)),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.only(right: 33, left: 20),
              ),
            ),
          ),
          BlocBuilder<ExclusiveservicelistCubit, ExclusiveserviceslistState>(
            builder: (context, state) {
              // Show loading spinner while fetching data
              if (state is ExclusiveserviceStateLoading) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Show error message in case of failure
              if (state is ExclusiveserviceStateFailure) {
                return SizedBox(
                  height: 200,
                  child: Center(child: Text(state.msg ?? 'Failed to load')),
                );
              }

              // Show loaded services
              if (state is ExclusiveserviceStateLoaded) {
                final list = state.exclusiveServicesModel.data?.data ?? [];
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('No exclusive services found')),
                  );
                }

                // Return the list of services with pagination
                return CustomScrollView(
                  slivers: [
                    // List of services
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final service = list[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      (service.imageUrl != null &&
                                          service.imageUrl!.isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: service.imageUrl!,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          height: 120,
                                        )
                                      : const Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey,
                                        ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Avatar + name
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundImage: AssetImage(
                                              'assets/images/bannerimg.png',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            service.name ?? 'Unknown',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff222222),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'segeo',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Title
                                      Text(
                                        service.name ?? 'No Title',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff222222),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'segeo',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Description
                                      Text(
                                        service.description ??
                                            'No description available.',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'segeo',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: list.length),
                    ),

                    // Loading more indicator when user scrolls to the bottom
                    if (state is ExclusiveserviceStateLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 1.6),
                          ),
                        ),
                      ),
                  ],
                );
              }

              // Show default message if no data is available
              return const Center(child: Text('No data available'));
            },
          ),
        ],
      ),
    );
  }
}
