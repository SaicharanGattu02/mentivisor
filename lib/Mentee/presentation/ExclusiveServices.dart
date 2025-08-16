import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServiceList_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_state.dart';

import '../../utils/color_constants.dart';

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
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: CustomAppBar1(title: "Exclusive Services", actions: const []),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F8FF), Color(0xFFF4F5FA)],
          ),
        ),
        child: Column(
          children: [
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
                  hintText: "Search by Name",
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
            BlocBuilder<ExclusiveservicelistCubit, ExclusiveserviceslistState>(
              builder: (context, state) {
                if (state is ExclusiveserviceStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExclusiveserviceStateFailure) {
                  return Center(child: Text(state.msg ?? 'Failed to load'));
                } else if (state is! ExclusiveserviceStateLoaded) {
                  return const Center(child: Text('No data available'));
                } else {
                  final list = state.exclusiveServicesModel.data?.data ?? [];
                  return Expanded(
                    child: CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                          ),
                        ),
                        if (list.isEmpty)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 48),
                              child: Center(
                                child: Text('No exclusive services found'),
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                            sliver: SliverList.separated(
                              itemCount: list.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final serviceList = list[index];
                                return _ServiceCard(
                                  imageUrl: serviceList.imageUrl ?? '',
                                  authorName: serviceList.name ?? '',
                                  title: serviceList.name ?? '',
                                  description: serviceList.description ?? '',
                                  onTap: () {
                                    context.push(
                                      '/service_details?id=${serviceList.id}',
                                    ); // pass whole model (optional)
                                  },
                                );
                              },
                            ),
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
}

class _ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String authorName;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.imageUrl,
    required this.authorName,
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
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEF6).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
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
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
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
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage('assets/images/bannerimg.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    authorName,
                    style: const TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 12,
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
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
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
