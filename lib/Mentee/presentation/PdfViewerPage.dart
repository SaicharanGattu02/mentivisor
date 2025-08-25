// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
//
// import '../../core/network/mentee_endpoints.dart';
// import '../../services/ApiClient.dart';
//
// class PdfViewerPage extends StatefulWidget {
//   final String? income_id;
//   final String? filing_id;
//   const PdfViewerPage({
//     Key? key,
//     required this.income_id,
//     required this.filing_id,
//   }) : super(key: key);
//
//   @override
//   _PdfViewerPageState createState() => _PdfViewerPageState();
// }
//
// class _PdfViewerPageState extends State<PdfViewerPage> {
//   String? _pdfPath;
//   bool _isLoading = true;
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAndSavePdf();
//   }
//
//   bool _isPdf = true; // Flag to indicate whether the content is a PDF or image
//
//   Future<void> _fetchAndSavePdf() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       Response response;
//       if (widget.income_id != "") {
//         response = await ApiClient.get(
//           '${APIEndpointUrls.income_invoice_generate}${widget.income_id}/',
//           options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: true,
//             headers: {
//               'Content-Type': null, // overrides/removes global header
//               'Accept': null, // let server pick; curl didn’t set this
//             },
//             validateStatus: (c) => c != null && c >= 200 && c < 500,
//           ),
//         );
//       } else {
//         response = await ApiClient.get(
//           '${APIEndpointUrls.ca_report}${widget.filing_id}/',
//           options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: true,
//             headers: {
//               'Content-Type': null, // overrides/removes global header
//               'Accept': null, // let server pick; curl didn’t set this
//             },
//             validateStatus: (c) => c != null && c >= 200 && c < 500,
//           ),
//         );
//       }
//
//       // Sanity check: should be a PDF
//       final ct = response.headers.value('content-type') ?? '';
//       if (!ct.contains('application/pdf')) {
//         // Handle image (PNG)
//         if (ct.contains('image/png')) {
//           final bytes = response.data is Uint8List
//               ? response.data as Uint8List
//               : Uint8List.fromList((response.data as List<int>));
//
//           final tempDir = await getTemporaryDirectory();
//           final file = File('${tempDir.path}/image_${widget.filing_id}.png');
//           await file.writeAsBytes(bytes, flush: true);
//
//           // Show image path and update UI
//           setState(() {
//             _pdfPath = file.path;
//             _isPdf = false; // Set to false since it's an image
//             // _errorMessage = 'Received image instead of PDF';
//             _isLoading = false;
//           });
//
//           // Optionally, you can open the image using Image widget or external viewer
//           return;
//         }
//
//         String body = '';
//         try {
//           if (response.data is List<int> || response.data is Uint8List) {
//             body = utf8.decode(
//               (response.data as List<int>),
//               allowMalformed: true,
//             );
//           } else if (response.data is String) {
//             body = response.data as String;
//           }
//         } catch (_) {}
//
//         throw Exception(
//           'Expected PDF but got: "$ct". Body: ${body.isEmpty ? "<binary or empty>" : body}',
//         );
//       }
//
//       // Normal case: save PDF file
//       final bytes = response.data is Uint8List
//           ? response.data as Uint8List
//           : Uint8List.fromList((response.data as List<int>));
//
//       final tempDir = await getTemporaryDirectory();
//       final file = File('${tempDir.path}/invoice_${widget.income_id}.pdf');
//       await file.writeAsBytes(bytes, flush: true);
//
//       setState(() {
//         _pdfPath = file.path;
//         _isPdf = true; // Set to true since it's a PDF
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error: $e';
//       });
//       AppLogger.error('PDF fetch error: $e');
//     }
//   }
//
//   Future<void> _downloadPdf() async {
//     try {
//       final downloadsDir = await getExternalStorageDirectory();
//       final file = File(
//         '${downloadsDir!.path}/invoice_${widget.income_id}.pdf',
//       );
//       final tempDir = await getTemporaryDirectory();
//       final tempFile = File('${tempDir.path}/invoice_${widget.income_id}.pdf');
//       await tempFile.copy(file.path);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('PDF downloaded to ${file.path}')));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error downloading PDF: $e')));
//     }
//   }
//
//   Future<void> _printOrSaveExistingPdf() async {
//     try {
//       if (_pdfPath == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No file to print/share yet')),
//         );
//         return;
//       }
//
//       final file = File(_pdfPath!);
//
//       // If it's a PDF, print or share as PDF
//       if (_isPdf) {
//         final bytes = await file.readAsBytes();
//
//         // Option A: system print dialog (with “Save as PDF” on most platforms)
//         await Printing.layoutPdf(onLayout: (format) async => bytes);
//
//         // Option B: native share sheet (mail, Drive, Files app, etc.)
//         // await Printing.sharePdf(bytes: bytes, filename: 'invoice_${widget.income_id}.pdf');
//       }
//       // If it's an image, share the image
//       else {
//         // Create XFile for sharing
//         final xFile = XFile(file.path);
//
//         // Sharing the image using SharePlus
//         await Share.shareXFiles([xFile], text: 'CA Report Image');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Print/Share error: $e')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar1(
//         title: "PDF Viewer",
//         actions: [
//           if (_pdfPath != null) ...[
//             // Show Print icon if it's a PDF
//             if (_isPdf) ...[
//               IconButton(
//                 tooltip: 'Print / Save',
//                 icon: const Icon(Icons.print),
//                 color: Colors.black,
//                 onPressed: _printOrSaveExistingPdf,
//               ),
//             ]
//             // Show Share icon if it's an image
//             else ...[
//               IconButton(
//                 tooltip: 'Share Image',
//                 icon: const Icon(Icons.share),
//                 color: Colors.black,
//                 onPressed: _printOrSaveExistingPdf,
//               ),
//             ],
//           ],
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: DottedProgressWithLogo())
//           : _errorMessage != null
//           ? Center(child: Text(_errorMessage!))
//           : _pdfPath != null
//           ? _isPdf
//                 ? PDFView(
//                     filePath: _pdfPath!,
//                     enableSwipe: true,
//                     autoSpacing: true,
//                     pageFling: true,
//                     onError: (err) {
//                       AppLogger.error('PDFView onError: $err');
//                       setState(() => _errorMessage = 'Viewer error: $err');
//                     },
//                     onPageError: (page, err) {
//                       AppLogger.error('PDFView onPageError: $page, $err');
//                     },
//                     onRender: (pages) {
//                       AppLogger.info('PDF rendered with $pages pages');
//                     },
//                   )
//                 : Center(
//                     child: PhotoView(imageProvider: FileImage(File(_pdfPath!))),
//                   ) // Display image using PhotoView // Display image if it's a PNG
//           : const Center(child: Text('No PDF available')),
//     );
//   }
// }
