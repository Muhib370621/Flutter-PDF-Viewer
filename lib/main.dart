import 'dart:io';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              openfile(
                url:
                    "http://aghasteel.us.tempcloudsite.com/ftp_ledger/0001002923202208.pdf",
                filename: "muhibdoc.pdf",
              );
            },
            child: Text("View"),
          ),
        ],
      ),
    );
  }
}
Future openfile({required url, String?filename}) async {
  final file = await downloadFile(url, filename!);
  if (file==null) return null;
  print(file.path);
  OpenFile.open(file.path);
}

Future<File?> downloadFile(String url, String name) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final file = File('${appStorage.path}/$name');
  try {
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ),
    );
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  } catch(e) {
    return null;
  }
}
