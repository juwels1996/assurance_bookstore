import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookPdfPreviewScreen extends StatelessWidget {
  final String pdfUrl;

  const BookPdfPreviewScreen({Key? key, required this.pdfUrl})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(pdfUrl, key: _pdfViewerKey),
    );
  }
}
