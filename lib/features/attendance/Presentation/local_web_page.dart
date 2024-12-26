// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class LocalWebPage extends StatelessWidget {
//   final String qrCode;
//   final Function() onAttendanceConfirmed;
//
//   LocalWebPage({required this.qrCode, required this.onAttendanceConfirmed});
//
//   @override
//   Widget build(BuildContext context) {
//     const htmlContent = """
//     <!DOCTYPE html>
//     <html lang="en">
//     <head>
//       <meta charset="UTF-8">
//       <meta name="viewport" content="width=device-width, initial-scale=1.0">
//       <title>Confirm Attendance</title>
//       <style>
//         body { font-family: Arial, sans-serif; text-align: center; }
//         .button { padding: 10px 20px; background-color: green; color: white; border: none; cursor: pointer; }
//       </style>
//     </head>
//     <body>
//       <h1>Confirm Attendance</h1>
//       <p>QR Code: {QR_CODE}</p>
//       <button class="button" onclick="confirm()">Confirm</button>
//       <script>
//         function confirm() {
//           FlutterWebView.postMessage('confirmed');
//         }
//       </script>
//     </body>
//     </html>
//     """;
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Confirm Attendance')),
//       body: WebView(
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (controller) {
//           controller.loadHtmlString(htmlContent.replaceAll('{QR_CODE}', qrCode));
//         },
//         javascriptChannels: {
//           JavascriptChannel(
//             name: 'FlutterWebView',
//             onMessageReceived: (message) {
//               if (message.message == 'confirmed') {
//                 onAttendanceConfirmed();
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalWebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login for Attendance'),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadFlutterAsset('assets/www/index.html'),
      ),
    );
  }
}
