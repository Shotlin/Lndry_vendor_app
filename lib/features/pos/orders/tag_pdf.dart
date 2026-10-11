import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/pos/pos_counter_order_model.dart';

/// Plain ASCII for the built-in PDF font (garment names in other scripts would print as boxes).
String _ascii(String s) => s.runes
    .map((r) => r >= 32 && r < 127 ? String.fromCharCode(r) : '?')
    .join()
    .replaceAll(RegExp(r'\?{2,}'), '?')
    .trim();

/// One small label per garment: the shop, the order, the garment and a QR of its tag code. A roll-printer or the
/// share sheet gets one page per tag. The tag CODE is created by the server; this only lays it out.
Future<Uint8List> buildTagsPdf(
    {required String orderNumber,
    required String shopName,
    required List<GarmentUnit> units,
    required List<CounterOrderItem> items}) async {
  final doc = pw.Document(title: 'Tags $orderNumber', author: 'LNDRY');
  const format = PdfPageFormat(50 * PdfPageFormat.mm, 30 * PdfPageFormat.mm,
      marginAll: 2 * PdfPageFormat.mm);
  final perItem = <int, int>{};
  for (final u in units) {
    perItem[u.itemIndex] = (perItem[u.itemIndex] ?? 0) + 1;
  }
  for (final u in units) {
    final service = u.itemIndex >= 0 && u.itemIndex < items.length
        ? items[u.itemIndex].serviceName
        : '';
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (_) => pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: u.tagCode,
                width: 22 * PdfPageFormat.mm,
                height: 22 * PdfPageFormat.mm),
            pw.SizedBox(width: 2 * PdfPageFormat.mm),
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (shopName.trim().isNotEmpty)
                    pw.Text(_ascii(shopName),
                        style: const pw.TextStyle(fontSize: 6), maxLines: 1),
                  pw.Text(_ascii(orderNumber),
                      style: const pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold),
                      maxLines: 1),
                  pw.Text(_ascii(u.garmentName),
                      style: const pw.TextStyle(fontSize: 8), maxLines: 2),
                  if (service.isNotEmpty)
                    pw.Text(_ascii(service),
                        style: const pw.TextStyle(fontSize: 6), maxLines: 1),
                  pw.Text('${u.sequence}/${perItem[u.itemIndex]}',
                      style: const pw.TextStyle(fontSize: 7)),
                  pw.Text(_ascii(u.tagCode),
                      style: const pw.TextStyle(fontSize: 5.5), maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  return doc.save();
}
