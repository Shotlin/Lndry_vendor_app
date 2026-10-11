import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../repositories/abstract/pos_repositories.dart';

/// Shows a PDF with Share and Print. A seam: the app uses the real viewer, tests swap in a plain widget
/// (the viewer needs a phone's printing service).
typedef PosPdfViewerBuilder = Widget Function(BuildContext context, PosPdf pdf,
    {VoidCallback? onDone});

Widget _realViewer(BuildContext context, PosPdf pdf, {VoidCallback? onDone}) =>
    PdfPreview(
      build: (_) async => pdf.bytes,
      pdfFileName: pdf.fileName,
      canChangeOrientation: false,
      canChangePageFormat: false,
      canDebug: false,
      allowPrinting: true,
      allowSharing: true,
      maxPageWidth: 520,
      onPrinted: onDone == null ? null : (_) => onDone(),
      onShared: onDone == null ? null : (_) => onDone(),
    );

final posPdfViewerProvider =
    Provider<PosPdfViewerBuilder>((ref) => _realViewer);
