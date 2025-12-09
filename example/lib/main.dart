import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:daou_sample_app/daou_sample_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await DaouSampleApp.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // SimpleTest 함수 호출 및 결과를 팝업으로 표시
  Future<void> callSimpleTest(BuildContext dialogContext) async {
    // BuildContext를 async 작업 전에 저장
    final BuildContext context = dialogContext;
    
    String result;
    try {
      result = await DaouSampleApp.callSimpleTest() ?? 'No result returned';
    } on PlatformException catch (e) {
      result = 'Failed to call SimpleTest: ${e.message}';
    } catch (e) {
      result = 'Error: $e';
    }

    // mounted 체크 후 showDialog 호출
    if (!mounted) return;

    // 팝업창으로 결과 표시
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('SimpleTest 결과'),
          content: SingleChildScrollView(
            child: Text(result),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Running on: $_platformVersion\n'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => callSimpleTest(scaffoldContext),
                    child: const Text('SimpleTest 호출'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
