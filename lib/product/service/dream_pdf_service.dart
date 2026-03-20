import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../service/dream_journal_service.dart';

class DreamPdfService {
  static Future<void> generateAndShare(DreamEntry dream) async {
    final pdf = pw.Document();

    // Fontları yükle (isteğe bağlı ama Türkçe karakterler için gerekli olabilir)
    // final font = await PdfGoogleFonts.interRegular();
    // final boldFont = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Ruya Defteri', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text(dream.createdAt.toString().split(' ')[0]),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(dream.title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(dream.content, style: const pw.TextStyle(fontSize: 14)),
              pw.Spacer(),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('NafieSna tarafindan olusturuldu', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    
    // Geçici bir dosya oluştur
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${dream.title.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(bytes);

    // Paylaş
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: dream.title,
    );
  }
}
