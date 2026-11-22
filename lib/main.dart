import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart'; // استيراد صفحة الواجهة التي أنشأناها

void main() async {
  // 1. التأكد من تهيئة بيئة تشغيل فلاتر أولاً
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تهيئة فايربيز مع الخيارات المناسبة للنظام (أندرويد أو iOS)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 3. تشغيل التطبيق
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء علامة وضع الديباج
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // تشغيل الصفحة الرئيسية الجديدة بدلاً من العداد الافتراضي
      home: const HomePage(), 
    );
  }
}