import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nominal_roll/Screens/auth/supbaseinit.dart';
import 'package:nominal_roll/Screens/home.dart/constant.dart';

class AddStaff extends StatefulWidget {
  final String emiscode;
  final String school;
  final String job;
  final String mmunit;
  const AddStaff({super.key, required this.emiscode, required this.school, required this.job, required this.mmunit});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  String name = '';
  String staffid = '';
  String grade = '';
  String munit = '';

  final _signUp = GlobalKey<FormState>();

  Widget _entryField(String title, {bool isPassword = false, icon, message, keyBoardtype, bool required = true, String? field,}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: keyBoardtype,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: const Color(0xfff3f3f4),
              filled: true,
              prefixIcon: Icon(icon, color: Colors.indigo.shade900),
              labelText: title,
              helperText: title,
              labelStyle: TextStyle(fontFamily: 'pangolin', color: Colors.indigo.shade900),
            ),
            validator: required
                ? (val) => val!.isEmpty
                    ? message
                    : field == 'password'
                        ? val.length <= 5
                            ? 'Password is too short'
                            : null
                        : null
                : null,
            onChanged: (val) {
              setState(() {
                if (field == 'name') {
                  name = val;
                } else if (field == 'staffid') {
                  staffid = val;
                } else if (field == 'munit') {
                  munit = val;
                } else if (field == 'grade') {
                  grade = val;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_signUp.currentState!.validate()) {
          try {
            EasyLoading.show(status: 'Adding...');
            await supabase.from('nominalroll').insert({
              'school': widget.school,
              'staff_id': staffid,
              'full_name': name,
              'job_grade': grade,
              'management_unit': munit,
              'emis_code': widget.emiscode
            });
            EasyLoading.dismiss();
            toast(msg: '$name has been added successfully', bgcolor: Colors.green, textcolor: Colors.white);

            // ignore: use_build_context_synchronously
            Navigator.pop(context, true);
          } catch (e) {
            toast(bgcolor: Colors.red, msg: e.toString(), textcolor: Colors.white);
          }

          // print(userData.toMap());
          // Loader.show(context, progressIndicator: CircularProgressIndicator());

          // if (results == 'Success') {
          //   Loader.hide();
          //   Navigator.pop(context);
          // } else if (results == 'Email Taken') {
          //   Loader.hide();
          //   print('Email Taken');
          // }
          // Future.delayed(Duration(seconds: 10), () {
          //   Loader.hide();
          // });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.blue, Colors.blue]),
        ),
        child: const Text(
          'Add',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'NEW STAFF',
            style: TextStyle(fontSize: 15),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
          child: SingleChildScrollView(
              child: Form(
            key: _signUp,
            child: Column(children: [
              const Text('Add a new Staff Member'),
              _entryField('Staff ID',
                  field: 'staffid',
                  
                  icon: Icons.account_box,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Type 0000 if no Staff ID'),
              _entryField('Full Name',
                  field: 'name',
                  icon: Icons.person,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Provide the Full Name of the new Staff member'),
              _entryField('Grade / Job',
                  field: 'grade',
                  icon: Icons.grade,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Type the grade. eg.${widget.job}'),
              _entryField('Mangement Unit',
                  field: 'munit',
                  icon: Icons.work,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Type the grade. eg.${widget.mmunit}'),
              _submitButton()
            ]),
          )),
        ));
  }
}
