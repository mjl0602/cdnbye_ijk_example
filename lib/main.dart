import 'package:cdnbye/cdnbye.dart';
import 'package:cdnbye_ijk_example/global/p2pListener.dart';
import 'package:cdnbye_ijk_example/pages/listPage.dart';
import 'package:flutter/material.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var uri = await getTemporaryDirectory();
  LocalCacheSync.instance.setCachePath(uri.path);
  Cdnbye.init(
    'free', // replace with your token
    config: P2pConfig(
      logLevel: P2pLogLevel.debug,
    ),
    infoListener: (Map<dynamic, dynamic> info) {
      // 写入消息
      P2pGlobalListener().videoInfo.value = info.cast<String, dynamic>();
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CDNBYE IJK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPage(),
    );
  }
}
