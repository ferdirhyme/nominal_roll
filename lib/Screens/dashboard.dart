import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nominal_roll/Screens/auth/months.dart';
import 'package:nominal_roll/Screens/auth/supbaseinit.dart';
import 'package:nominal_roll/Screens/database/db.dart';
import 'package:nominal_roll/Screens/home.dart/addstaff.dart';
import 'package:nominal_roll/Screens/home.dart/edit.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  // db kk =  db();
  Map profileData = {};
  Map emisCodeData = {};
  List nominalRollData = [];
  List unapproved = [];
  List approved = [];
  String approvedDate = '';
  // List<dynamic> allapprovedDates = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  getDate() async {
    try {
      // Fetch the current date and time from an NTP server
      DateTime currentTime = await NTP.now();

      setState(() {
        approvedDate = months[currentTime.month.toString()] + currentTime.year.toString();
        // approvedDate = months[DateTime.now().month.toString()] + DateTime.now().year.toString();
      });
    } catch (e) {
      // print(e);
    }
  }

  approve(id, arr) async {
    try {
      await supabase.from('nominalroll').update({'approv': '$arr'}).match({'id': id});
    } catch (e) {
      // print(e.toString());
    }
  }

  getUserProfile() async {
    getDate();

    var data = supabase.auth.currentUser;
    var user = data?.id;
    var getprofileData = await supabase.from('profiles').select('*').eq('id', user);
    setState(() {
      profileData = getprofileData[0];
    });
    var getEmisData = await supabase.from('emiscodes').select('*').eq('school_code', profileData['emiscode']);
    setState(() {
      emisCodeData = getEmisData[0];
    });
    var getNominalRollData = await supabase.from('nominalroll').select('*').eq('emis_code', profileData['emiscode']);
    setState(() {
      nominalRollData = getNominalRollData;
    });
    setState(() {
      for (int i = 0; i <= nominalRollData.length - 1; i++) {
        if (nominalRollData[i]['approv'] == approvedDate) {
          approved.add(nominalRollData[i]);
        } else {
          unapproved.add(nominalRollData[i]);
        }
      }
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      nominalRollData = [];
      unapproved = [];
      approved = [];
    });
    getUserProfile();

    _refreshController.refreshCompleted();
  }

  void delete(id) async {
    await supabase.from('nominalroll').delete().eq('id', id);
  }

  showAlertDialog(BuildContext context, id, name) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        delete(id);
        setState(() {
          nominalRollData = [];
          unapproved = [];
          approved = [];
        });
        getUserProfile();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm"),
      content: Text("Are you sure you want to delete $name from your Staff List?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getDate();
    getUserProfile();
    // getinstituion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),

        // onLoading: _onLoading,
        child: Scaffold(
          drawer: GFDrawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                GFDrawerHeader(
                  currentAccountPicture: const GFAvatar(
                    radius: 80.0,
                    backgroundImage: AssetImage("assets/img/logo.png"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        emisCodeData['head_of_institution'] != null
                            ? Text(
                                emisCodeData['head_of_institution'],
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              )
                            : const Text(''),
                        emisCodeData['institution'] != null
                            ? Text(
                                emisCodeData['institution'],
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Add Staff'),
                  tileColor: Colors.grey,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => AddStaff(
                            emiscode: nominalRollData[0]['emis_code'],
                            job: nominalRollData[0]['job_grade'],
                            mmunit: nominalRollData[0]['management_unit'],
                            school: nominalRollData[0]['school'],
                          ),
                        ))
                        .then((_) => setState(() {}));
                    // Navigator.pushNamed(context, '/page2').then((_) => setState(() {}));
                  },
                  trailing: const Icon(
                    Icons.person_add_alt,
                    color: Colors.green,
                  ),
                ),
                ListTile(
                  title: const Text('Refresh'),
                  tileColor: Color.fromRGBO(158, 158, 158, 1),
                  onTap: () {
                    setState(() {
                      nominalRollData = [];
                      unapproved = [];
                      approved = [];
                    });
                    getUserProfile();
                    Navigator.of(context).pop();
                  },
                  trailing: const Icon(
                    Icons.refresh,
                    color: Colors.red,
                  ),
                ),
                const Gap(200),
                const ListTile(
                  title: Text('Sign Out'),
                  tileColor: Colors.grey,
                  onTap: null,
                  trailing: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emisCodeData['institution'] != null ? Text(emisCodeData['institution'].toString().toUpperCase()) : const Text('SCHOOL'),
                const Text('NOMINAL ROLL DATA')
              ],
            ),
            centerTitle: true,
            bottom: const TabBar(
              indicatorWeight: 10,
              labelColor: Colors.white,
              indicatorColor: Colors.grey,
              tabs: [
                Tab(
                    text: 'NOT APPROVED',
                    icon: Icon(
                      Icons.not_interested,
                      color: Colors.red,
                    )),
                Tab(
                    text: 'APPROVED',
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                    )),
              ],
            ),
          ),
          body: TabBarView(
            //UNAPPROVED LIST
            children: [
              unapproved.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: unapproved.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.amber),
                      itemBuilder: (BuildContext context, int index) {
                        // return nominalRollData[index]['approved'].toString() != 'true'
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text(unapproved[index]['full_name'])),
                            ],
                          ),
                          subtitle: Column(children: [
                            Row(
                              children: [const Text('STAFF ID: '), Expanded(child: Text(unapproved[index]['staff_id']))],
                            ),
                            Row(
                              children: [const Text('JOB/GRADE: '), Expanded(child: Text(unapproved[index]['job_grade']))],
                            ),
                            Row(
                              children: [
                                const Text('MANAGEMENT UNIT: '),
                                Expanded(child: Text(unapproved[index]['management_unit'].toString().trim()))
                              ],
                            ),
                            Row(
                              children: [
                                GFButton(
                                  onPressed: () {
                                    // delete(unapproved[index]['id']);
                                    showAlertDialog(context, unapproved[index]['id'], unapproved[index]['full_name']);
                                  },
                                  text: "DELETE",
                                  icon: const Icon(Icons.delete),
                                  type: GFButtonType.solid,
                                  color: Colors.red,
                                ),
                                const Gap(20),
                                // GFButton(
                                //   onPressed: () {
                                //     Navigator.of(context).push(MaterialPageRoute(
                                //       builder: (context) => EditPage(
                                //         staffid: unapproved[index]['staff_id'],
                                //         id: unapproved[index]['id'],
                                //         name: unapproved[index]['full_name'],
                                //         job: unapproved[index]['job_grade'],
                                //         mmunit: unapproved[index]['management_unit'],
                                //       ),
                                //     ));
                                //   },
                                //   text: "EDIT",
                                //   icon: const Icon(Icons.edit_document),
                                //   type: GFButtonType.outline,
                                // ),
                                // const Gap(10),
                                Expanded(
                                  flex: 1,
                                  child: GFButton(
                                    onPressed: () {
                                      approve(unapproved[index]['id'], approvedDate);
                                      setState(() {
                                        nominalRollData = [];
                                        unapproved = [];
                                        approved = [];
                                      });
                                      getUserProfile();
                                    },
                                    text: "APPROVE",
                                    icon: const Icon(Icons.done),
                                    type: GFButtonType.outline,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )
                          ]),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.done_all,
                            color: Colors.green,
                            size: 50,
                          ),
                          approved.length == nominalRollData.length
                              ? const Text(
                                  'All Done!',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                  ),
                                )
                              : const CircularProgressIndicator(),
                          const Text('Pull down or up to Refresh the data on this page')
                        ],
                      ),
                    ),

              // APPROVED LIST
              approved.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: approved.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.amber),
                      itemBuilder: (BuildContext context, int index) {
                        // return nominalRollData[index]['approved'].toString() != 'true'
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text(approved[index]['full_name'])),
                            ],
                          ),
                          subtitle: Column(children: [
                            Row(
                              children: [const Text('STAFF ID: '), Expanded(child: Text(approved[index]['staff_id']))],
                            ),
                            Row(
                              children: [const Text('JOB/GRADE: '), Expanded(child: Text(approved[index]['job_grade']))],
                            ),
                            Row(
                              children: [
                                const Text('MANAGEMENT UNIT: '),
                                Expanded(child: Text(approved[index]['management_unit'].toString().trim()))
                              ],
                            ),
                            Row(
                              children: [
                                GFButton(
                                  onPressed: () {
                                    showAlertDialog(context, unapproved[index]['id'], unapproved[index]['full_name']);
                                  },
                                  text: "DELETE",
                                  icon: const Icon(Icons.delete),
                                  type: GFButtonType.solid,
                                  color: Colors.red,
                                ),
                                const Gap(20),
                                GFButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        staffid: approved[index]['staff_id'],
                                        id: approved[index]['id'],
                                        name: approved[index]['full_name'],
                                        job: approved[index]['job_grade'],
                                        mmunit: approved[index]['management_unit'],
                                      ),
                                    ));
                                  },
                                  text: "EDIT",
                                  icon: const Icon(Icons.edit_document),
                                  type: GFButtonType.outline,
                                ),
                              ],
                            )
                          ]),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.filter_list_off_sharp,
                            color: Colors.grey,
                            size: 50,
                          ),
                          Text(
                            'No Approvals yet!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
