import 'package:flutter/material.dart';
import 'package:local_cache_sync/local_cache_sync.dart';
import 'package:safemap/safemap.dart';

// 本地系统设置
class UserDefault {
  static var landscapeLeft = UserDefaultCache<bool>('landscapeLeft', false);
  static var token = UserDefaultCache<String>('token', 'free');
  static var autoplay = UserDefaultCache<bool>('autoplay', true);
  static var userHardware = UserDefaultCache<bool>('userHardware', false);
}

class UserDefaultCache<T> {
  final String key;
  final T defaultValue;

  UserDefaultCache(this.key, [this.defaultValue]);

  T get value => LocalCacheSync.userDefault[key] ?? defaultValue;

  set value(T value) {
    LocalCacheSync.userDefault[key] = value;
  }
}
