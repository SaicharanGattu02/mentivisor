import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_states.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';
import '../../Components/Shimmers.dart';
import 'Widgets/DownloadCard.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DownloadsCubit>().getDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Downloads",
        actions: [],
        // color: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "List",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<DownloadsCubit, DownloadStates>(
                  builder: (context, state) {
                    if (state is DownloadLoading) {
                      return DownloadListShimmer();
                    } else if (state is DownloadLoaded ||
                        state is DownloadLoadingMore) {
                      final downloadsModel = (state is DownloadLoaded)
                          ? (state as DownloadLoaded).downloadsModel
                          : (state as DownloadLoadingMore).downloadsModel;

                      final downloads = downloadsModel.data?.downloads ?? [];
                      final loadingMore = state is DownloadLoadingMore;
                      if (downloads.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/nodownloads.png",
                                height: 120,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No Downloads Available",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'segeo',
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          final nearBottom =
                              scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent * 0.9;
                          if (nearBottom &&
                              state is DownloadLoaded &&
                              state.hasNextPage) {
                            context.read<DownloadsCubit>().fetchMoreDownloads();
                          }
                          return false;
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverMasonryGrid.count(
                              crossAxisCount: _getCrossAxisCount(context),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childCount:
                                  downloads.length + (loadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (loadingMore && index == downloads.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(25.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 0.8,
                                      ),
                                    ),
                                  );
                                }
                                return DownloadCard(
                                  downloads: downloads[index],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text("No data found"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // 📱 Mobile
    } else if (width > 600) {
      return 2; // 💻 Tablet
    } else {
      return 3; // 🖥️ Desktop
    }
  }
}

class DownloadListShimmer extends StatelessWidget {
  const DownloadListShimmer({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1; // 📱 Mobile
    } else if (width < 900) {
      return 2; // 💻 Tablet
    } else {
      return 3; // 🖥️ Desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: _getCrossAxisCount(context), // 👈 Responsive
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childCount: 6, // shimmer placeholders
            itemBuilder: (context, index) => const _DownloadShimmerCard(),
          ),
        ),
      ],
    );
  }
}

class _DownloadShimmerCard extends StatelessWidget {
  const _DownloadShimmerCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 400;

        return Container(
          padding: EdgeInsets.all(isCompact ? 10 : 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Thumbnail shimmer
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: shimmerRectangle(isCompact ? 80 : 100, context),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerText(width * 0.45, 16, context), // Title
                    const SizedBox(height: 8),
                    shimmerText(width * 0.35, 12, context), // Subtitle
                    const SizedBox(height: 8),
                    shimmerText(width * 0.3, 12, context), // Secondary
                    const SizedBox(height: 10),
                    shimmerLinearProgress(40, context), // Download bar
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
