import 'package:cdnbye/cdnbye.dart';
import 'package:flutter/material.dart';

class P2pGlobalListener {
  // 工厂模式
  factory P2pGlobalListener() => _getInstance();
  static P2pGlobalListener get instance => _getInstance();
  static P2pGlobalListener _instance;
  P2pGlobalListener._internal() {
    // 初始化
    videoInfo = ValueNotifier({});
  }
  static P2pGlobalListener _getInstance() {
    if (_instance == null) {
      _instance = P2pGlobalListener._internal();
    }
    return _instance;
  }

  ValueNotifier<Map<String, dynamic>> videoInfo;
}

class P2pListener {
  Map<String, int> map = {};

  /// http下载量
  int get httpDownloaded => map['httpDownloaded'] ?? 0;
  String get httpDownloadedStr => '${httpDownloaded ~/ 1024} MB';

  /// p2p下载量
  int get p2pDownloaded => map['p2pDownloaded'] ?? 0;
  String get p2pDownloadedStr => '${p2pDownloaded ~/ 1024} MB';

  /// p2p上传量
  int get p2pUploaded => map['p2pUploaded'] ?? 0;
  String get p2pUploadedStr => '${p2pUploaded ~/ 1024} MB';

  /// peers
  int get peers => map['peers'] ?? 0;
  String get peersStr => '$peers';

  String version = '';
  String peerId = '';

  bool connected = false;

  void Function() _valueUpdate;

  startListen(void Function() valueUpdate) async {
    _valueUpdate = valueUpdate;
    version = await Cdnbye.platformVersion;
    P2pGlobalListener().videoInfo.addListener(_updateInfo);
    _valueUpdate?.call();
  }

  dispose() {
    P2pGlobalListener().videoInfo.removeListener(_updateInfo);
  }

  _updateInfo() {
    Map info = P2pGlobalListener().videoInfo.value;
    print('Received SDK info: $info');
    if (info.isNotEmpty) {
      String key = info.keys.toList().first;
      dynamic value = info.values.toList().first;
      if (value is int) {
        _addValue(key, value);
      } else if (value is List) {
        map[key] = value.length;
      }
    }
    _valueUpdate?.call();
    Cdnbye.isConnected().then((value) {
      connected = value;
      _valueUpdate?.call();
    });
    Cdnbye.getPeerId().then((value) {
      peerId = value;
      _valueUpdate?.call();
    });
  }

  /// 累加value到map中，如果没有就新建
  _addValue(key, value) {
    if (map.containsKey(key)) {
      map[key] += value;
    } else {
      map[key] = value;
    }
  }
}
