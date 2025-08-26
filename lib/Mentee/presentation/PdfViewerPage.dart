import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../../Components/CutomAppBar.dart';
import '../../services/ApiClient.dart';
import '../../utils/AppLogger.dart';

class PdfViewerPage extends StatefulWidget {
  final String? file_url;
  const PdfViewerPage({Key? key, required this.file_url}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _pdfPath;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSavePdf();
  }

  bool _isPdf = true; // Flag to indicate whether the content is a PDF or image

  Future<void> _fetchAndSavePdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Response response;
      response = await ApiClient.get(
        widget.file_url ?? "",
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          headers: {
            'Content-Type': null, // overrides/removes global header
            'Accept': null, // let server pick; curl didn’t set this
          },
          validateStatus: (c) => c != null && c >= 200 && c < 500,
        ),
      );
      // Sanity check: should be a PDF
      final ct = response.headers.value('content-type') ?? '';
      if (!ct.contains('application/pdf')) {
        String body = '';
        try {
          if (response.data is List<int> || response.data is Uint8List) {
            body = utf8.decode(
              (response.data as List<int>),
              allowMalformed: true,
            );
          } else if (response.data is String) {
            body = response.data as String;
          }
        } catch (_) {}

        throw Exception(
          'Expected PDF but got: "$ct". Body: ${body.isEmpty ? "<binary or empty>" : body}',
        );
      }

      // Normal case: save PDF file
      final bytes = response.data is Uint8List
          ? response.data as Uint8List
          : Uint8List.fromList((response.data as List<int>));

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/invoice.pdf');
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        _pdfPath = file.path;
        _isPdf = true; // Set to true since it's a PDF
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      AppLogger.error('PDF fetch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "PDF Viewer", actions: []),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _pdfPath != null
          ? PDFView(
              filePath: _pdfPath!,
              enableSwipe: true,
              autoSpacing: true,
              pageFling: true,
              onError: (err) {
                AppLogger.error('PDFView onError: $err');
                setState(() => _errorMessage = 'Viewer error: $err');
              },
              onPageError: (page, err) {
                AppLogger.error('PDFView onPageError: $page, $err');
              },
              onRender: (pages) {
                AppLogger.info('PDF rendered with $pages pages');
              },
            )
          : const Center(child: Text('No PDF available')),
    );
  }
}
