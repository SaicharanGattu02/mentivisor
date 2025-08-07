import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/Downloads/downloads_states.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Downloads'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DownloadsCubit, DownloadStates>(
          builder: (context, state) {
            if (state is DownloadLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DownloadLoaded ||
                state is DownloadLoadingMore) {
              final downloadsModel = (state is DownloadLoaded)
                  ? (state as DownloadLoaded).downloadsModel
                  : (state as DownloadLoadingMore).downloadsModel;
              final downloads = downloadsModel.downloads;
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.9) {
                    if (state is DownloadLoaded && state.hasNextPage) {
                      context.read<DownloadsCubit>().fetchMoreDownloads();
                    }
                    return false;
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList.separated(
                      itemCount: downloads?.length ?? 0,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) =>
                          DownloadCard(downloads: downloads![index]),
                    ),
                    if (state is DownloadLoadingMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 0.8),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return Center(child: Text("No data found"));
            }
          },
        ),
      ),
    );
  }
}
