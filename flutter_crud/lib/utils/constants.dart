import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  static String getBaseUrl() {
    if (kIsWeb) return 'http://localhost:8080/api'; // Flutter Web
    if (Platform.isAndroid) return 'http://192.168.1.180:8080/api'; // Android Emulator
    if (Platform.isIOS) return 'http://127.0.0.1:8080/api'; // iOS simulator
    return 'http://localhost:8080/api'; // Windows/Mac/Linux
  }

  static String getMinioUrl() {
    if (kIsWeb) return 'http://localhost:9000';
    if (Platform.isAndroid) return 'http://192.168.1.180:9000';
    if (Platform.isIOS) return 'http://127.0.0.1:9000';
    return 'http://localhost:9000';
  }
}
