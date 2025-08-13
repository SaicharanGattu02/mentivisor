import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/services/AuthService.dart';
import '../../utils/color_constants.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_cubit.dart';
import '../data/cubits/CampusMentorList/campus_mentor_list_state.dart';

class Campusmentorlist extends StatefulWidget {
  final String scope;
  const Campusmentorlist({super.key, required this.scope});

  @override
  State<Campusmentorlist> createState() => _CampusmentorlistState();
}

class _CampusmentorlistState extends State<Campusmentorlist> {
  String searchQuery = '';

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    print("scopeType=${widget.scope}");
    context.read<CampusMentorListCubit>().fetchCampusMentorList(
      "${widget.scope}",
      "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.isGuest,
      builder: (context, asyncSnapshot) {
        final isGuest = asyncSnapshot.data ?? false;
        return Scaffold(
          appBar: CustomAppBar1(
            title: isGuest
                ? "Top Mentors"
                : widget.scope == ""
                ? "On Campuses Mentors"
                : "Beyond Campuses Mentors",
            actions: [],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: searchController,
                    cursorColor: primarycolor,
                    onChanged: (query) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300),() {
                        context.read<CampusMentorListCubit>().fetchCampusMentorList("${widget.scope}",query,);
                      });
                    },
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search by employee name, phone',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                BlocBuilder<CampusMentorListCubit, CampusMentorListState>(
                  builder: (context, state) {
                    if (state is CampusMentorListStateLoading) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is CampusMentorListStateFailure) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(state.msg ?? 'Failed to load'),
                        ),
                      );
                    }
                    final list =
                        (state as CampusMentorListStateLoaded)
                            .campusMentorListModel
                            .data
                            ?.campusMentorData ??
                        [];
                    if (list.isEmpty) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: Text('No mentors found')),
                      );
                    }
                    return Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: list.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemBuilder: (ctx, i) {
                          final m = list[i];
                          return GestureDetector(
                            onTap: () {
                              if (isGuest) {
                                context.push('/auth_landing');
                              } else {
                                context.push('/mentor_profile?id=${m.id}');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey,
                                    child: ClipOval(
                                      child:
                                          (m.profilePicUrl != null &&
                                              m.profilePicUrl!.isNotEmpty)
                                          ? CachedNetworkImage(
                                              imageUrl: m.profilePicUrl!,
                                              fit: BoxFit.cover,
                                              width: 120,
                                              height: 120,
                                            )
                                          : const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    m.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff333333),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    m.designation ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xff555555),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/starvector.png",
                                        color: Colors.amber,
                                        height: 14,
                                        width: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        m.ratingsReceivedAvgRating
                                                ?.toStringAsFixed(1) ??
                                            '0.0',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'segeo',
                                          color: Color(0xff333333),

                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        "assets/images/coinsgold.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${m.ratingsReceivedCount ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
