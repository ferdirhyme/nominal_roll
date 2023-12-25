// import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

 toast({msg, bgcolor, textcolor}) {
   Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: bgcolor,
      textColor: textcolor,
      fontSize: 16.0);
}
