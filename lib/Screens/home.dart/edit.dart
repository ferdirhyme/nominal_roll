import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nominal_roll/Screens/auth/supbaseinit.dart';
import 'package:nominal_roll/Screens/home.dart/constant.dart';

class EditPage extends StatefulWidget {
  final int id;
  final String job;
  final String mmunit;
  final String name;
  final String staffid;
  // final String school;

  const EditPage({super.key, required this.id, required this.job, required this.mmunit, required this.name, required this.staffid});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String name = '';
  String staffid = '';
  String grade = '';
  String munit = '';
  final _edit = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController staffidController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController munitController = TextEditingController();

  Widget _entryField(
    String title, {
    bool isPassword = false,
    icon,
    message,
    keyBoardtype,
    bool required = true,
    String? field,
    String? intValue,
    TextEditingController? controller,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: controller,
            initialValue: intValue,
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

  Widget _submitButton(id) {
    return InkWell(
      onTap: () async {
        if (_edit.currentState!.validate()) {
          try {
            print(nameController.text);
            EasyLoading.show(status: 'Editing...');
            await supabase.from('nominalroll').update({
              'staff_id': staffidController.text,
              'full_name': nameController.text,
              'job_grade': gradeController.text,
              'management_unit': munitController.text,
            }).eq('id', id);
            EasyLoading.dismiss();
            toast(
              msg: 'Edit successfully',
              bgcolor: Colors.green,
              textcolor: Colors.white,
            );

            // ignore: use_build_context_synchronously
            Navigator.pop(context, true);
          } catch (e) {
            toast(bgcolor: Colors.red, msg: e.toString(), textcolor: Colors.white);
          }
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
          'Edit',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.name;
    gradeController.text = widget.job;
    staffidController.text = widget.staffid;
    munitController.text = widget.mmunit;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    gradeController.dispose();
    staffidController.dispose();
    munitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EDIT DATA',
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
            key: _edit,
            child: Column(children: [
              const Text('Add a new Staff Member'),
              _entryField('Staff ID',
                  controller: staffidController,
                  // intValue: widget.staffid,
                  field: 'staffid',
                  icon: Icons.account_box,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Type 0000 if no Staff ID'),
              _entryField('Full Name',
                  controller: nameController,
                  // intValue: widget.name,
                  field: 'name',
                  icon: Icons.person,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Provide the Full Name of the new Staff member'),
              _entryField('Grade / Job',
                  controller: gradeController,
                  // intValue: widget.job,
                  field: 'grade',
                  icon: Icons.grade,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Type the grade. eg.${widget.job}'),
              _entryField('Mangement Unit',
                  controller: munitController,
                  // intValue: widget.mmunit,
                  field: 'munit',
                  icon: Icons.work,
                  isPassword: false,
                  keyBoardtype: TextInputType.text,
                  required: true,
                  message: 'Type the grade. eg.${widget.mmunit}'),
              _submitButton(widget.id)
            ]),
          ),
        ),
      ),
    );
  }
}
