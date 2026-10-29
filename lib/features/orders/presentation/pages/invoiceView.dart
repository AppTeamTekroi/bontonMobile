import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class invoiceview extends StatefulWidget {
  final String pdfString;
  const invoiceview({required this.pdfString , super.key});

  @override
  State<invoiceview> createState() => _invoiceviewState();
}

class _invoiceviewState extends State<invoiceview> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INVOICE'), actions: [
        IconButton(onPressed: () {
          _launchInBrowser(Uri.parse(widget.pdfString));
        }, icon: Icon(Icons.download)),
        IconButton(
            onPressed: () {
              // Share.share(qc.currentorderpdf.value);
            },
            icon: Icon(Icons.share)),
      ]),
      body: Container(
        child: SfPdfViewer.network(
          widget.pdfString,
          key: _pdfViewerKey,
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
