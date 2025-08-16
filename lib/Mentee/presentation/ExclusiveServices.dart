import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServiceList_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServicesList/ExclusiveServicesList_state.dart';

class ExclusiveServices extends StatefulWidget {
  @override
  State<ExclusiveServices> createState() => _ExclusiveServicesScreenState();
}

class _ExclusiveServicesScreenState extends State<ExclusiveServices> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<ExclusiveservicelistCubit>().getExclusiveServiceList("");
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      context.read<ExclusiveservicelistCubit>().getExclusiveServiceList(q.trim());
    });
    setState(() {}); // just to refresh the clear icon visibility
  }

  void _clearSearch() {
    _searchCtrl.clear();
    context.read<ExclusiveservicelistCubit>().getExclusiveServiceList("");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: CustomAppBar1(title: "Exclusive Services", actions: const []),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F8FF), Color(0xFFF4F5FA)],
          ),
        ),
        child: BlocBuilder<ExclusiveservicelistCubit, ExclusiveserviceslistState>(
          builder: (context, state) {
            if (state is ExclusiveserviceStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExclusiveserviceStateFailure) {
              return Center(child: Text(state.msg ?? 'Failed to load'));
            }
            if (state is! ExclusiveserviceStateLoaded) {
              return const Center(child: Text('No data available'));
            }

            final list = state.exclusiveServicesModel.data?.data ?? [];
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Center(
                      child: Text(
                        "To Post your Services mail to rohit@gmail.com",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'segeo',
                          fontSize: 12,
                          color: Color(0xFF7B7F8C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // WORKING search field (kept identical styling)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0E1240).withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: _onSearchChanged,
                        onSubmitted: (v) => context
                            .read<ExclusiveservicelistCubit>()
                            .getExclusiveServiceList(v.trim()),
                        cursorColor: const Color(0xFF222222),
                        style: const TextStyle(fontFamily: 'segeo', fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF9AA0A6)),
                          hintText: 'Search by Name Here',
                          hintStyle: const TextStyle(
                            fontFamily: 'segeo',
                            fontSize: 14,
                            color: Color(0xFF9AA0A6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 12),
                          // optional clear button (not in mock, but handy)
                          suffixIcon: _searchCtrl.text.isEmpty
                              ? null
                              : IconButton(
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.clear, color: Color(0xFF9AA0A6)),
                            splashRadius: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (list.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(child: Text('No exclusive services found')),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    sliver: SliverList.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final s = list[index];
                        return _ServiceCard(
                          imageUrl: s.imageUrl ?? '',
                          authorName: s.name ?? 'Suraj',
                          title: s.name ?? 'A Travel Tricking',
                          description: s.description ?? '',
                          onTap: () {
                            context.push('/executiveinfoservices${s.id}', extra: s); // pass whole model (optional)
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
                        child: CircularProgressIndicator(strokeWidth: 1.6),
                      ),
                    ),
                  ),
              ],
            );
          },
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
                          child: CircularProgressIndicator(strokeWidth: 1.8),
                        ),
                      ),
                      errorWidget: (c, _, __) =>
                      const Icon(Icons.broken_image_outlined, color: Colors.grey),
                    )
                        : const Icon(Icons.broken_image_outlined, color: Colors.grey),
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
