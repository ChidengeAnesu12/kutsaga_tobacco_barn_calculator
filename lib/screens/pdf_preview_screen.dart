import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../widgets/app_header.dart';

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({
    super.key,
    required this.title,
    required this.fileName,
    required this.loadBytes,
    this.allowPrinting = true,
  });

  final String title;
  final String fileName;
  final Future<Uint8List> Function() loadBytes;
  final bool allowPrinting;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  late final Future<Uint8List> _bytesFuture;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _bytesFuture = widget.loadBytes();
  }

  Future<void> _sharePdf() async {
    setState(() => _isSharing = true);
    try {
      final bytes = await _bytesFuture;
      final shared = await Printing.sharePdf(
        bytes: bytes,
        filename: widget.fileName,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            shared ? 'PDF ready to share or save.' : 'PDF sharing cancelled.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF sharing failed: $error')));
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: widget.title,
        actions: [
          IconButton(
            icon: _isSharing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.ios_share),
            color: Colors.white,
            tooltip: 'Share or save PDF',
            onPressed: _isSharing ? null : _sharePdf,
          ),
        ],
      ),
      body: SafeArea(
        child: PdfPreview(
          build: (_) => _bytesFuture,
          allowPrinting: widget.allowPrinting,
          allowSharing: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          dynamicLayout: false,
          pdfFileName: widget.fileName,
          loadingWidget: const Center(child: CircularProgressIndicator()),
          onError: (_, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'PDF could not be opened: $error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
