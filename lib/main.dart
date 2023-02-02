import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vest_bag/components/navigation_control.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart';
import './services/api.dart';

final logger = Logger();
const accessToken = String.fromEnvironment('ACCESS_TOKEN', defaultValue: '');

void main() {
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  String url = 'https://google.com';
  int loadingPercentage = 0;
  late WebViewController controller;
  late WebView webview;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
        });
      }, onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      }));
    fetchWebView(context);
  }

  void fetchWebView(BuildContext context) async {
    var dio = Dio();
    dio.options.headers['Authorization'] = "Bearer $accessToken";
    var client = RestClient(dio);

    try {
      webview = await client.getWebView();

      controller.loadRequest(Uri.parse(webview.url ??= url));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request failed. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vest Bag'),
        actions: [NavigationControls(controller: controller)],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            )
        ],
      ),
    );
  }
}
