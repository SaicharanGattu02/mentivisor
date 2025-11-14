import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/Campuses/campuses_cubit.dart';
import '../../data/cubits/Campuses/campuses_states.dart';

class CollegeSelectionSheet extends StatefulWidget {
  final Function(String name, int id) onSelect;

  const CollegeSelectionSheet({super.key, required this.onSelect});

  @override
  State<CollegeSelectionSheet> createState() => _CollegeSelectionSheetState();
}

class _CollegeSelectionSheetState extends State<CollegeSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<CampusesCubit>().getCampuses("");
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// 🔍 Debounce Search
  void _onSearchChanged(String value) {
    searchQuery = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CampusesCubit>().getCampuses(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Campuses List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            /// 🔍 Search Input
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search college...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// LIST + PAGINATION
            Expanded(
              child: BlocBuilder<CampusesCubit, CampusesStates>(
                builder: (context, state) {
                  if (state is CampusesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CampusesFailure) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state case CampusesLoaded(:final campusesModel, :final hasNextPage) ||
                  CampusesLoadingMore(:final campusesModel, :final hasNextPage)) {

                    final campuses = campusesModel.data?.campuses ?? [];

                    if (campuses.isEmpty) {
                      return const Center(child: Text("No campuses found"));
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 50 &&
                            hasNextPage &&
                            state is! CampusesLoadingMore) {
                          context.read<CampusesCubit>().fetchMoreCampuses(searchQuery);
                        }
                        return false;
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverList.builder(
                            itemCount: campuses.length,
                            itemBuilder: (context, index) {
                              final item = campuses[index];
                              return ListTile(
                                title: Text(item.name ?? ""),
                                onTap: () {
                                  widget.onSelect(item.name!, item.id!);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),

                          if (state is CampusesLoadingMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(child: CircularProgressIndicator()),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

