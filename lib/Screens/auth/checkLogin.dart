import 'package:flutter/material.dart';
import 'package:nominal_roll/Screens/auth/login.dart';
import 'package:nominal_roll/Screens/auth/supbaseinit.dart';
import 'package:nominal_roll/Screens/dashboard.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  void initState() {
    super.initState();
    _redirect(context);
  }

  Future<void> _redirect(BuildContext context) async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    // final session = Supabase.instance.client.auth.currentSession;
    print(session);
    if (session != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Login(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
