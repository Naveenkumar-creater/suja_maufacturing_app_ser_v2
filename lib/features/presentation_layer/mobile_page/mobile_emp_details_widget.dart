import 'dart:async';
import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/shift_status_model.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_emp_production_entry.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_close_shift_widget.dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_production_entry.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/employe_allocation_popup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/request_data_model/send_attendence_model.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MobileEmployeeDetailsList extends StatefulWidget {
  // final int id;
  // final int shiftid;
  final int deptid;
  final int? psid;

  final Function? refreshCallback;

  const MobileEmployeeDetailsList({
    Key? key,
    // required this.id,
    // required this.shiftid,
    required this.deptid,
    this.refreshCallback,
    this.psid,
  }) : super(key: key);

  @override
  State<MobileEmployeeDetailsList> createState() =>
      _MobileEmployeeDetailsListState();
}

class _MobileEmployeeDetailsListState extends State<MobileEmployeeDetailsList> {
  EmployeeApiService employeeApiService = EmployeeApiService();
  AttendanceCountService attendanceCountService = AttendanceCountService();
  final ScrollController _scrollController1 = ScrollController();
  int? _selectedIndex; // State variable to store the selected index

  late int? initialindex;
  bool isLoading = true;

  void showEmployeeAllocationPopup(
    int? empPersonid,
    int? mfgpempid,
    int? processId,
    int? deptid,
    // int? shitid
  ) async {
    // Capture the valid context before the asynchronous operation
    final validContext = context;
    showDialog(
      context: validContext,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 400,
            height: 500,
            decoration: BoxDecoration(color: Colors.white),
            child: EmployeeAllocationPopup(
              empId: empPersonid,
              // mfgpempid: mfgpempid,
              processid: processId,
              //  shiftid: shitid,
              deptid: deptid,
              psid: widget.psid,
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
    // loadEmployeeList();
  }

  // Future<void> loadEmployeeList()  async{
  //   try {
  //     final int? process_id =
  //         Provider.of<ShiftStatusProvider>(context, listen: false)
  //             .user
  //             ?.shiftStatusdetailEntity
  //             ?.psMpmId;

  //     employeeApiService.employeeList(
  //         context: context,
  //         deptid: widget.deptid,
  //         processid: process_id ?? 0,
  //         psid: widget.psid ?? 0);

  //     setState(() {
  //       isLoading = true; // Set isLoading to false when data is fetched
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     // print('Error fetching asset list: $e');
  //     setState(() {
  //       isLoading = false; // Set isLoading to false even if there's an error
  //     });
  //   }
  // }

  // void loadEmployeeList() {
  //   employeeApiService.employeeList(context: context, id: widget.id);
  // }
  // void handleToggleAction(int index) async {
  //   await loadEmployeeList();
  // }

  Future<void> sendAttendance(int? index, String? attendanceid,
      int? empPersonid, String? flattdate) async {
    final process_id = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .processId;
    final shitId = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;
    final shiftStatus = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftStatus;
    final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    final attdid = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .attendanceid;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    DateTime now = DateTime.now();
    //DateTime today = DateTime(now.year, now.month, now.day);;

    int dt;

    dt = int.tryParse(attendanceid ?? "") ?? 0;

    final requestBody = SendAttendencereqModel(
        apiFor: "floor_attendance",
        clientAuthToken: token,
        attId: dt,
        attStatus: index,
        deptId: widget.deptid,
        empid: empPersonid,
        processId: process_id,
        psid: widget.psid,
        shiftId: Shiftid,
        shiftStatus: shiftStatus, pwsId: 0);

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

  void _closeShiftPop(
    BuildContext context,
    String attenceid,
    int attendceStatus,
    int empPersonid,
    int processid,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                  ),
                  child: Column(children: [
                    const Text("Confirm you submission"),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await employeeApiService.employeeList(
                                  context: context,
                                  processid: processid ?? 0,
                                  deptid: widget.deptid ?? 1,
                                  psid: widget.psid ?? 0,
                                );

                                // Call the EmpClossShift.empCloseShift method

                                await EmpClosesShift.empCloseShift(
                                    'emp_close_shift',
                                    widget.psid ?? 0,
                                    1,
                                    attenceid ?? " ",
                                    attendceStatus ?? 0);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MobileEmpProductionEntryPage(
                                      empid: empPersonid!,
                                      processid: processid ?? 1,
                                      deptid: widget.deptid,
                                      isload: true,
                                      attenceid: attenceid,
                                      attendceStatus: attendceStatus,
                                      // shiftId: widget.shiftid,
                                      psid: widget.psid,
                                    ),
                                  ),
                                );
                              } catch (error) {
                                // Handle and show the error message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.amber,
                                  ),
                                );
                              }
                            },
                            child: const Text("Submit"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Go back")),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
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

    final int? process_id =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.psMpmId;
    double ScreenWidth = MediaQuery.of(context).size.width;
    double Screenheight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left:8.0,right: 8),
        child: Container( decoration: BoxDecoration(
                    // color: Color.fromARGB(150, 235, 236, 255),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Colors.grey.shade400)),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: employeeResponse?.length ?? 0,
              itemBuilder: (context, index) {
                final employee = employeeResponse![index];
                DateTime now = DateTime.now();
                String today = DateFormat('yyyy-MM-dd').format(now);
          
                String? dt = employee.flattdate;
                int? shiftstatus = employee?.flattshiftstatus;
                initialindex = employee.flattstatus;
          
                String? flattDate = dt; // Parse dt to DateTime if not null
          
                String attdate = flattDate ?? "";
                return GestureDetector(
                  child: Container(alignment: Alignment.center,width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border(bottom:BorderSide(width: 1,color: Colors.grey.shade300) ),
                      color: _selectedIndex == index
                          ? Color.fromARGB(110, 163, 173, 236)
                          : null,
                    ), // Set unique background color for selected tile
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee!.personFname ?? "",
                          style: TextStyle(
                              color: Colors.black54, fontFamily: "Lexend"),
                        ),
                       
                        // _selectedIndex != index
                        //     ? Container(
                        //         width: double.infinity,
                        //         height: 1,
                        //         decoration:
                        //             BoxDecoration(color: Colors.grey.shade300),
                        //       )
                        //     : Container(
                        //         width: double.infinity,
                        //         height: 0,
                        //         decoration:
                        //             BoxDecoration(color: Colors.grey.shade300),
                        //       )
                      ],
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      _selectedIndex = index;
                      // Update selected index
                    });
                    //                         final processId = processList[index].processId ?? 0;
                    //                         final deptId = processList[index].deptId ?? 0;
                    //                         try {
                    //                           // Perform shiftStatusService first
                    //                                 // Navigator.pop(context);
                    //                           await shiftStatusService.getShiftStatus(
                    //                               context: context,
                    //                               deptid: deptId,
                    //                               processid: processId);
                    //                           final psId = Provider.of<ShiftStatusProvider>(context,
                    //                                       listen: false)
                    //                                   .user
                    //                                   ?.shiftStatusdetailEntity
                    //                                   ?.psId ??
                    //                               0;
                              
                    //                           // Perform employeeApiService next
                    //                           await employeeApiService.employeeList(
                    //                               context: context,
                    //                               processid: processId,
                    //                               deptid: deptId,
                    //                               psid: psId);
                              
                    //                           // Continue with other asynchronous operations sequentially
                    //                           await attendanceCountService.getAttCount(
                    //                               context: context, id: processId, deptid: deptId, psid: psId);
                              
                    //                           await actualQtyService.getActualQty(
                    //                               context: context, id: processId,psid: psId);
                              
                    //                           await planQtyService.getPlanQty(
                    //                               context: context, id: processId, psid: psId);
                    // Navigator.pop(context);
                              
                    //                         } catch (e) {
                    //                           // Handle any errors that occur during the async operations
                    //                           print('Error fetching data: $e');
                    //                         }
                  },
                );
              }),
        ),
      ),
    );
  }
}
