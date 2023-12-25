import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nominal_roll/Screens/auth/checkLogin.dart';
// import 'package:nominal_roll/Screens/auth/login.dart';
// import 'package:nominal_roll/Screens/auth/supbaseinit.dart';
// import 'package:nominal_roll/Screens/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ecwmnvmovjrqmrcvawwo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjd21udm1vdmpycW1yY3Zhd3dvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkxOTEwNjksImV4cCI6MjAxNDc2NzA2OX0.5YKlbFhpZjePsnOXRI3BjVwZHrqfCLSglPt5MHSG-Nc',
    authFlowType: AuthFlowType.pkce,
  );

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const CheckLogin(),
      builder: EasyLoading.init(),
    );
  }
}
