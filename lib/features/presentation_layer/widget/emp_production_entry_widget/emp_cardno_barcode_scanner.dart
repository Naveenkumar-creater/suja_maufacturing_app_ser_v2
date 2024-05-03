import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:suja/constant/show_pop_error.dart';
import 'package:suja/features/presentation_layer/api_services/card_no_di.dart';
import 'package:suja/features/presentation_layer/widget/homepage_widget/emp_production_entry.dart';


class CardNoScanner extends StatefulWidget {
  final int? empId;
  final int? processId;
  final int?shiftId;
  const CardNoScanner({
    super.key, this.empId, this.processId, this.shiftId
  });



  @override
  State<CardNoScanner> createState() => _CardNoScannerState();
}

class _CardNoScannerState extends State<CardNoScanner> {
     final CardNoApiService  cardNoApiService =CardNoApiService();
  late String _barcodeResult = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: widget.themeState.isDarkTheme
        //     ? const Color(0xFF424242)
           color : Colors.grey.shade200,
      ),
      child: InkWell(
        onTap: _scanQrCode,
        child: const Column(
          children: [
        
              Icon(
                Icons.camera_alt,
                color: Colors.blue,
                size: 40,
              )
            // Headings(
            //   text: "Scan Barcode",
            // )
          ],
        ),
      ),
    );
  }

Future<void> _scanQrCode() async {
  String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
    '#00FF00', // Overlay color (green)
    'Cancel',  // Cancel button text
    true,      // Show flash icon
    ScanMode.QR, // Scan mode (QR code in this case)
  );

  // Check if the result is empty or if the scan was canceled
  if (barcodeResult.isEmpty || barcodeResult == '-1') {
    // Show an alert or toast indicating invalid barcode

    ShowError.showAlert(context,'Invalid barcode or scan canceled' );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Invalid barcode or scan canceled'),
    //     duration: Duration(seconds: 2),
    //   ),
    
    // return;
  }

  try {
    // Call cardNoApiService.getCardNo
    await cardNoApiService.getCardNo(
        context: context, cardNo: int.tryParse(barcodeResult) ?? 0);

    setState(() {
      _barcodeResult = barcodeResult;
    });

 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EmpProductionEntryPage(
          empid: widget.empId,
          processid: widget.processId,
          shiftId: widget.shiftId,
          isload: false,
          cardno: 1,
        ),
      ),
    );
  } catch (e) {
    // Show an alert or toast indicating error

        ShowError.showAlert(context,'Error: Failed to fetch card number' );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Error: Failed to fetch card number'),
    //     duration: Duration(seconds: 2),
    //   ),
    // );
  }
}
}