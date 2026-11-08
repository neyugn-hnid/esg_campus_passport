import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Demo mode: bỏ qua Firebase, dùng dữ liệu mẫu
  runApp(const ESGApp(demoMode: true));
}
