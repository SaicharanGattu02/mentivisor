import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CommonLoader.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_states.dart';
import 'package:mentivisor/Mentee/presentation/Widgets/CommonBackground.dart';
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
        child: Padding(
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
                      return const Center(child: DottedProgressWithLogo());
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
