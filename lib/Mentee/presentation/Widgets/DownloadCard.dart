import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/Mentee/Models/DownloadsModel.dart';

import '../../../Components/CustomAppButton.dart';

class DownloadCard extends StatelessWidget {
  final Downloads downloads;
  const DownloadCard({Key? key, required this.downloads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/download.jpg",
                height: 145,
                width: 145,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    downloads.title ?? "",
                    maxLines: 1,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Text(
                    downloads.description ?? "",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 6.0, // space between tags
                    children:
                        downloads.tag?.map((tag) {
                          return Text(
                            tag,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                  SizedBox(height: 15),
                  CustomOutlinedButton(
                    text: "View",
                    radius: 24,
                    onTap: () {
                      context.push(
                        "/pdf_viewer?file_url=${downloads.filePath}",
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
