import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'login_view.dart';


class QRZafiro extends StatefulWidget {
  const QRZafiro({Key? key}) : super(key: key);

  @override
  _QRZafiroState createState() => _QRZafiroState();
}

class _QRZafiroState extends State<QRZafiro> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      controller.stopCamera();
      /*Future.delayed(Duration.zero, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView(result: result!.code)));
      });*/
      Navigator.pop(context, result!.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


