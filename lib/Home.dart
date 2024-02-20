import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// ignore: must_be_immutable
  late InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri("https://ssdesk.in/v2"),
                ),
                // initialUrlRequest: URLRequest(url: Uri.parse(initialurl)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useOnDownloadStart: true,
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onLoadStart:
                    (InAppWebViewController controller, WebUri? url) {},
                onLoadStop: (InAppWebViewController controller, WebUri? url) {},
                onDownloadStartRequest: (controller, url) async {
                  // Check and request storage permission
                  var status = await Permission.storage.status;
                  //if (status.isGranted) {
                  // Get the external storage directory
                  Directory? tempDir = await getExternalStorageDirectory();

                  // Print the download details
                  print("onDownload ${url.url.toString()}\n ${tempDir!.path}");

                  // Enqueue the download using flutter_downloader
                  await FlutterDownloader.enqueue(
                    url: url.url.toString(),
                    fileName: url.suggestedFilename ?? 'downloaded_file',
                    savedDir: tempDir.path,
                    showNotification: true,
                    requiresStorageNotLow: false,
                    openFileFromNotification: true,
                    saveInPublicStorage: true,
                  );
                  // } else {
                  //   // Request storage permission
                  //   await Permission.storage.request();
                  // }
                }),
          ),
        ])),
      ),
    );
  }
}


//   bool isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     final WebViewController controller =
//         WebViewController.fromPlatformCreationParams(
//             const PlatformWebViewControllerCreationParams());
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse('/'));

//     return Scaffold(
//       body: SafeArea(
//         child: WebViewWidget(

//           controller: controller,
//         ),
//       ),
//     );
//   }
// }
