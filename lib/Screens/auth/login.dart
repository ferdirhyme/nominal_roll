import 'package:flutter/material.dart';

import 'package:flutter_login/flutter_login.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nominal_roll/Screens/auth/supbaseinit.dart';
import 'package:nominal_roll/Screens/dashboard.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class _LoginState extends State<Login> {
  Duration get loginTime => const Duration(milliseconds: 2250);
  final auth = supabase.auth;
  late List check;
  final storage = FlutterSecureStorage();

  Future<String?> _authUser(LoginData data) async {
    try {
      await auth.signInWithPassword(password: data.password, email: data.name);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List> fetchEmisCode(SignupData data) async {
    final emisData = await supabase
        .from('emiscodes')
        .select('school_code, password')
        .match({'school_code': data.additionalSignupData!.values.first, 'password': data.password});

    return emisData;
  }

  insertProfileData(data) async {
    var userId = await supabase.auth.currentUser;
    var user = userId?.id;
    await supabase
        .from('profiles')
        .insert({'emiscode': data.additionalSignupData!.values.first, 'id': user, 'full_name': 'name', 'avatar_url': 'pic'});
  }

  Future<String?> _signupUser(SignupData data) async {
    final validEmisCode = fetchEmisCode(data);

    await validEmisCode.then((value) {
      check = value;
      print(check);
    });
    // print(check);
    if (check.isNotEmpty) {
      try {
        // final response =
        await auth.signUp(password: data.password!, email: data.name);
        await insertProfileData(data);
        // message = 'A verification Email has been sent to ${response.user!.email}';
        return null;
      } catch (e) {
        if (e.toString() == 'AuthException(message: Email rate limit exceeded, statusCode: 429)') {
          return 'Server Busy. Please try again after 30min';
        }
        return e.toString();
      }
    }
    return 'Invalid Emis Code or Password';
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await auth.resetPasswordForEmail(name, redirectTo: 'https://ferdirhyme.github.io/nominal-roll-reset-password/');
      // message = 'A verification Email has been sent to ${response.user!.email}';
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      footer: 'Copyright © 2023, FerdIT',
      // title: 'Tema Metro Education',
      // logoTag: 'Tema Metro Education',

      // showDebugButtons: true,
      logo: const AssetImage('assets/img/logo.png'),

      // loginProviders: <LoginProvider>[
      //   LoginProvider(
      //     icon: FontAwesomeIcons.google,
      //     label: 'Google',
      //     callback: () async {
      //       debugPrint('start google sign in');
      //       await Future.delayed(loginTime);
      //       debugPrint('stop google sign in');
      //       return null;
      
      //     },
      //   ),

      // ],
      onLogin: _authUser,
      onSignup: _signupUser,
      loginAfterSignUp: true,
      hideForgotPasswordButton: true,
      // theme: LoginTheme(),
      scrollable: true,
      additionalSignupFields: const [
        UserFormField(
          keyName: 'emisCode',
          displayName: 'School Emis Code',
          icon: Icon(Icons.code),
          defaultValue: '',
          userType: LoginUserType.phone,
        )
      ],

      messages: LoginMessages(
          recoverPasswordSuccess: 'Password reset link sent to your Email',
          // confirmSignupSuccess: 'A confirmation link has been sent to your Email',
          flushbarTitleError: 'Error',
          flushbarTitleSuccess: 'Success',
          recoverPasswordDescription: 'A reset link would be sent to you Email',
          recoverPasswordIntro: 'Enter Your Email Here'),

      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
