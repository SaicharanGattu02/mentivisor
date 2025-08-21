import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar1(
        title: "Downloads",
        actions: [],
        // color: Colors.transparent,
      ),
      body: Background(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text("List",style: TextStyle(color: Color(0xff444444),fontSize: 20, fontWeight:FontWeight.w600,fontFamily: "segeo"),),
                ),

                Expanded(
                  child: BlocBuilder<DownloadsCubit, DownloadStates>(
                    builder: (context, state) {
                      if (state is DownloadLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DownloadLoaded || state is DownloadLoadingMore) {
                        final downloadsModel = (state is DownloadLoaded)
                            ? (state as DownloadLoaded).downloadsModel
                            : (state as DownloadLoadingMore).downloadsModel;

                        final downloads = downloadsModel.downloads ?? [];
                        final loadingMore = state is DownloadLoadingMore;

                        return NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            final nearBottom = scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent * 0.9;
                            if (nearBottom && state is DownloadLoaded && state.hasNextPage) {
                              context.read<DownloadsCubit>().fetchMoreDownloads();
                            }
                            return false;
                          },
                          child: ListView.separated(
                            itemCount: downloads.length + (loadingMore ? 1 : 0),
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              if (loadingMore && index == downloads.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Center(
                                    child: CircularProgressIndicator(strokeWidth: 0.8),
                                  ),
                                );
                              }
                              return DownloadCard(downloads: downloads[index]); // <-- return
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
      ),
    );
  }
}
