import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/Models/DownloadsModel.dart';
import 'package:mentivisor/Mentee/data/cubits/DownloadDelete/DownloadActionCubit.dart';
import 'package:mentivisor/Mentee/data/cubits/DownloadDelete/DownloadActionStates.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Components/CustomAppButton.dart';
import '../../../utils/media_query_helper.dart';
import '../../../utils/spinkittsLoader.dart';
import '../../data/cubits/Downloads/downloads_cubit.dart';

class DownloadCard extends StatelessWidget {
  final Downloads downloads;
  const DownloadCard({Key? key, required this.downloads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: CachedNetworkImage(
                  width: SizeConfig.screenWidth * 0.28,
                  height: 144,
                  imageUrl: downloads.image ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    width: 120,
                    height: 120,
                    child: Center(child: spinkits.getSpinningLinespinkit()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 120,
                    height: 120,
                    color: Color(0xffF8FAFE),
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                downloads.title ?? "",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                downloads.description ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        BlocConsumer<DownloadActionCubit, DownloadActionStates>(
                          listener: (context, state) {
                            if (state is DownloadActionSuccess) {
                              context.read<DownloadsCubit>().getDownloads();
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is DownloadActionLoading;
                            return IconButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context
                                          .read<DownloadActionCubit>()
                                          .downloadAction(
                                            downloads.downloadId.toString() ??
                                                "",
                                          );
                                    },
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                              icon: Image.asset(
                                'assets/icons/delete.png',
                                width: 25,
                                height: 25,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if ((downloads.tag?.isNotEmpty ?? false))
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics:
                            const BouncingScrollPhysics(), // 👈 gives you the smooth bounce
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 8,
                          runSpacing: 8,
                          children: downloads.tag!.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF7F8FC),
                                    Color(0xFFEFF4FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontFamily: 'segeo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    SizedBox(height: 15),
                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: CustomOutlinedButton(
                            text: "View",
                            radius: 24,
                            onTap: () {
                              context.push(
                                "/pdf_viewer?file_url=${downloads.filePath}",
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomAppButton1(
                            text: "Share",
                            radius: 24,
                            onPlusTap: () {
                              final study_zone_Id = downloads.downloadId;
                              final shareUrl =
                                  "https://mentivisor.com/study_zone/$study_zone_Id";
                              Share.share(
                                "Check out this Study Zone on Mentivisor:\n$shareUrl",
                                subject: "Mentivisor Study Zone",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
