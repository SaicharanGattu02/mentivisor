import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        child: ListView.separated(
                          itemCount: downloads.length + (loadingMore ? 1 : 0),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
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
                            ); // <-- return
                          },
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
}

class DownloadListShimmer extends StatelessWidget {
  const DownloadListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6, // show 6 shimmer placeholders
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
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
              /// 🔹 Thumbnail / Preview Box
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: shimmerRectangle(100, context),
              ),
              const SizedBox(width: 12),

              /// 🔹 Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerText(180, 16, context), // Title
                    const SizedBox(height: 8),
                    shimmerText(140, 12, context), // Subtitle / Description
                    const SizedBox(height: 8),
                    shimmerText(120, 12, context), // Secondary line

                    const SizedBox(height: 10),

                    /// 🔹 Optional progress shimmer (simulate download bar)
                    shimmerLinearProgress(8, context),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// 🔹 Action Icon (Download / Play)
              shimmerCircle(32, context),
            ],
          ),
        );
      },
    );
  }
}
