import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:suja/features/presentation_layer/api_services/employee_di.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../constant/request_model.dart';
import 'emp_production_entry.dart';
import '../../../../constant/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../api_services/process_di.dart';
import '../../provider/employee_provider.dart';
import 'employe_allocation_popup.dart';

class EmployeeDetailsList extends StatefulWidget {
  final int id;
  final int shiftid;
  final Function? refreshCallback;

  const EmployeeDetailsList({
    Key? key,
    required this.id,
    required this.shiftid,
    this.refreshCallback,
  }) : super(key: key);

  @override
  State<EmployeeDetailsList> createState() => _EmployeeDetailsListState();
}

class _EmployeeDetailsListState extends State<EmployeeDetailsList> {
  EmployeeApiService employeeApiService = EmployeeApiService();
  AttendanceCountService attendanceCountService =AttendanceCountService();

  late int? initialindex;
  bool isLoading = true;

 void showEmployeeAllocationPopup(
    int? empPersonid,
    int? mfgpempid,
    int? processId,
    int? shitid
  ) async {
  // Capture the valid context before the asynchronous operation
  final validContext = context;
    showDialog  (
      context: validContext,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 400,
            height: 500,
            decoration: BoxDecoration(color: Colors.white),
            child:  EmployeeAllocationPopup(
              empId: empPersonid,
              mfgpempid: mfgpempid,
              processid: processId,
               shiftid: shitid,

            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Load employee list initially
    loadEmployeeList();
  }

  Future<void> loadEmployeeList() async {
    try {
      await employeeApiService.employeeList(context: context, id: widget.id,shiftid: widget.shiftid);
      setState(() {
        isLoading = true; // Set isLoading to false when data is fetched
      });
    } catch (e) {
      // ignore: avoid_print
      // print('Error fetching asset list: $e');
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
  }

  // void loadEmployeeList() {
  //   employeeApiService.employeeList(context: context, id: widget.id);
  // }
  // void handleToggleAction(int index) async {
  //   await loadEmployeeList();
  // }


  Future<void> sendAttendance(int? index, int? attendanceid, int? empPersonid,
      String? flattdate) async {
    final empid = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .empPersonid;
    final attdid = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .attendanceid;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    DateTime now = DateTime.now();
    //DateTime today = DateTime(now.year, now.month, now.day);;
    String today = DateFormat('yyyy-MM-dd').format(now);

    String toDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    int dt;
    if (flattdate != today) {
      dt = attendanceid!;
    } else {
      dt = 0;
    }
    final requestBody = ApiRequestDataModel(
      apiFor: "floor_attendance",
      clientAuthToken: token,
      attstatus: index,
      attdate: toDate,
      attintime: toDate,
      emppersonid: empPersonid,
      attid: dt,
    );
    final requestBodyjson = jsonEncode(requestBody.toJson());

    print(requestBodyjson);

    const timeoutDuration = Duration(seconds: 30);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBodyjson,
          )
          .timeout(timeoutDuration);

      // ignore: avoid_print
      print(response.body);

      if (response.statusCode == 200) {
        try {
          final responseJson = jsonDecode(response.body);
          // loadEmployeeList();
          print(responseJson);
          return responseJson;
        } catch (e) {
          // Handle the case where the response body is not a valid JSON object
          throw ("Invalid JSON response from the server");
        }
      } else {
        throw ("Server responded with status code ${response.statusCode}");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeResponse =
        Provider.of<EmployeeProvider>(context, listen: true)
            .user
            ?.listofEmployeeEntity;
    print(employeeResponse);
    final empid =
        employeeResponse?.isNotEmpty == true ? employeeResponse!.indexed : null;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    color: Color.fromARGB(255, 45, 54, 104),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                            width: 50,
                            child: Text('S.NO',
                                style: TextStyle(color: Colors.white))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            child: Text('Name',
                                style: TextStyle(color: Colors.white))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text('Prev Product',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150,
                          alignment: Alignment.center,
                          child: Text('Prev Time',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 90,
                          alignment: Alignment.center,
                          child: Text('Attendance',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 120,
                          alignment: Alignment.center,
                          child: Text('Allocation',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 120,
                          alignment: Alignment.center,
                          child: Text('Indv Productivity',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text('',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: employeeResponse?.length ?? 0,
                  itemBuilder: (context, index) {
                    final employee = employeeResponse![index];
                    DateTime now = DateTime.now();
                    String today = DateFormat('yyyy-MM-dd').format(now);

                    String? dt = employee.flattdate;
                    initialindex = employee.flattstatus;

                    DateTime? flattDate = dt != null
                        ? DateTime.parse(dt)
                        : null; // Parse dt to DateTime if not null

                    String attdate = flattDate != null
                        ? DateFormat('yyyy-MM-dd').format(flattDate)
                        : ""; // Format flattDate if not null

                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300)),
                        color: index % 2 == 0
                            ? Colors.grey.shade50
                            : Colors.grey.shade100,
                      ),
                      height: 85,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(alignment: Alignment.center,
                                width: 50,
                                child: Text('${index + 1}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,fontSize: 12))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(alignment: Alignment.center,
                                width: 120,
                                child: Text(employee?.personFname ?? '',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,fontSize: 12))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(alignment: Alignment.center,
                                width: 100,
                                child: Text(employee?.productName ?? '',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,fontSize: 12))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(alignment: Alignment.center,
                                width: 150,
                                child: Text(employee.timing.toString(),
                                    style: TextStyle(
                                        color: Colors.grey.shade600,fontSize: 12))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(alignment: Alignment.center,
                              width: 90,
                              child: ToggleSwitch(
                                minWidth: 40.0,
                                cornerRadius: 20.0,
                                activeBgColors: [
                                  [Colors.red[800]!],
                                  [Colors.green[800]!]
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                initialLabelIndex: initialindex,
                                totalSwitches: 2,
                                labels: ['A', 'P'],
                                radiusStyle: true,
                                onToggle: (index) async {
                                  await sendAttendance(
                                    index,
                                    employee.attendanceid,
                                    employee.empPersonid,
                                    employee.flattdate,
                                  );
                                  print('switched to: $index');
                            
                                 employeeApiService.employeeList(
                                      context: context,
                                      id: employee.processId ?? 0,shiftid: widget.shiftid ?? 1);
                                      attendanceCountService.getAttCount(context: context, id:employee.processId ?? 0);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Container(alignment: Alignment.center,
                              width: 120,
                              child: ElevatedButton(
                                child: Text("change"),
                                onPressed: initialindex ==
                                        0 // Disable the button if toggle label is "A"
                                    ? null
                                    : () {
                                        setState(() {
                                          
                                          showEmployeeAllocationPopup(
                                            employee.empPersonid,
                                            employee.mfgpempid,
                                            employee.processId,
                                            widget?.shiftid ??0
                                            
                                          );
                                                                employeeApiService.employeeList(
                                          context: context, id:employee.processId??0,shiftid: widget.shiftid??1);
                                        });
                                      },
                              ),
                            ),
                          ),
                         
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(width: 120,alignment: Alignment.center,
                              child: Text('200',
                                  style: TextStyle(color: Colors.grey.shade600,fontSize: 12)),
                            ),
                          ), Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed:
                                    // Access the EmployeeProvider
                                    initialindex ==
                                            0 // Disable the button if toggle label is "A"
                                        ? null
                                        : () {
                                            final employeeProvider =
                                                Provider.of<EmployeeProvider>(
                                                    context,
                                                    listen: false);
                            
                                            // Get the employee ID of the current employee
                                            final employeeId =
                                                employeeResponse[index]
                                                    .empPersonid;
                            
                                            // Update the employee ID in the provider
                                            employeeProvider
                                                .updateEmployeeId(employeeId!);
                            
                                            // Navigate to the ProductionQuantityPage
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EmpProductionEntryPage(
                                                  empid: employee.empPersonid!,
                                                  processid:
                                                     widget.id ?? 1,
                                                     isload: true,
                                                     shiftId: widget.shiftid,
                                                ),
                                              ),
                                            );
                                            employeeApiService.employeeList(
                                                context: context,
                                                id: employee.processId ?? 0,
                                                shiftid: widget.shiftid);
                                          },
                                child: Text("Add"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
