import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../cekout_screen.dart';

void createPDF(Map<String, dynamic> data) {
  List count = data['nama_produk'];
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Rincian Pesanan',
                  style: pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("NAMA PEMESAN",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    data['nama'],
                    style: pw.TextStyle(
                        color: PdfColors.grey,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("TANGGAL CHECKOUT",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    DateFormat('dd-MM-yyyy')
                        .format(
                        DateTime.parse(data['tgl_order']))
                        .toString(),
                    style: pw.TextStyle(
                        color: PdfColors.grey,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("METODE PEMBAYARAN",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    data['payment'],
                    style: pw.TextStyle(
                        color: PdfColors.grey,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("NOMOR ORDER",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    Get.arguments['id'],
                    style: pw.TextStyle(
                        color: PdfColors.grey,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("TANGGAL ORDER",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    data['tgl_order'].toString(),
                    style: pw.TextStyle(
                        color: PdfColors.grey,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Status",
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    data['status'].toString(),
                    style: pw.TextStyle(
                        color: PdfColors.grey,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(data['take'].toString().toUpperCase(),
                      style: pw.TextStyle(
                          color: PdfColors.orange,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    'JAM ' +
                        data['jam'].toString().toUpperCase(),
                    style: pw.TextStyle(
                        color: PdfColors.orange,
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
              pw.SizedBox(height: 20),
              garis,
              pw.SizedBox(height: 20),
              pw.SizedBox(
                  width: Get.width,
                  child: pw.Text(
                    'Menu yang di pesan',
                    style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.orange),
                    textAlign: pw.TextAlign.center,
                  )
              ),
              pw.SizedBox(
                  height: 150,
                  width: Get.width,
                  child: pw.ListView.builder(
                    itemBuilder: (context, index) {
                      return pw.Column(
                        crossAxisAlignment:
                        pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                            pw.MainAxisAlignment
                                .spaceBetween,
                            children: [
                              pw.Text(
                                  data['nama_produk'][index]
                                      .toString(),
                                  style: pw.TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                      pw.FontWeight.bold,
                                      height: 1.5)),
                              pw.Text(
                                  'x ' +
                                      ((int.parse(data['total'][index]) / int.parse(data['harga'][index]))
                                          .floor())
                                          .toString(),
                                  style: pw.TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                      pw.FontWeight.bold,
                                      color: PdfColors.black,
                                      height: 1.5)),
                            ],
                          ),
                          garis,
                          pw.SizedBox(
                            width: Get.width,
                            child: pw.Text(
                              'Rp.' +
                                  data['total'][index]
                                      .toString(),
                              style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.grey),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          garis,
                          pw.SizedBox(height: 20)
                        ],
                      );
                    },
                    itemCount: count.length,
                  )),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total Pesanan",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rp.' +
                      Get.arguments['totals'].toString(),
                      style: pw.TextStyle(
                          color: PdfColors.orange,
                          fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
  Printing.layoutPdf(onLayout: (format) => pdf.save());
}

var garis = pw.Container(
  decoration: pw.BoxDecoration(
      border:
      pw.Border(bottom: pw.BorderSide(color: PdfColors.grey))),
);