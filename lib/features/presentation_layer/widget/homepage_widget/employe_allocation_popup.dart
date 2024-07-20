import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/constant/request_data_model/emp_process_change_model.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/presentation_layer/api_services/allocatio_di.dart';
import 'package:prominous/features/domain/entity/AllocationEntity.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/provider/allocation_provider.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/request_model.dart';
import '../../../../constant/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../api_services/process_di.dart';
import 'employee_details_list.dart';

class EmployeeAllocationPopup extends StatefulWidget {
  final int? empId;

  final int? processid;
  // final int? shiftid;
  final int? deptid;
  final int? psid;

  final int? attid;
  final int? mfgpeid;

  EmployeeAllocationPopup(
      {required this.empId,
      required this.processid,
      // required this.shiftid,
      this.deptid,
      required this.psid,
      this.attid,
      this.mfgpeid});

  @override
  _EmployeeAllocationPopupState createState() =>
      _EmployeeAllocationPopupState();
}

class _EmployeeAllocationPopupState extends State<EmployeeAllocationPopup> {
  String? selectedItem;
  int? selectedProcessId;
  AllocationService allocationService = AllocationService();
  EmployeeApiService employeeApiService = EmployeeApiService();
    AttendanceCountService attendanceCountService = AttendanceCountService();

  ListofworkstationService listofworkstationService =
      ListofworkstationService();
    ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllocationList();
    // employeeApiService.employeeList(context: context, id: widget.processid!, shiftid: widget.shiftid);
  }

  Future<void> _fetchAllocationList() async {
    try {
      await allocationService.changeallocation(
          context: context, id: widget.empId ?? 0, deptid: widget.deptid ?? 0);
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

  Future<void> sendProcess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    DateTime now = DateTime.now();

    final requestBody = EmpProcessChange(
        apiFor: "change_process_v1",
        clientAutToken: token,
        flAttId: widget.attid,
        mfgpeId: widget.mfgpeid,
        mfgpeMpmId: selectedProcessId,
        mfgpePersonId: widget.empId,
        pwsePwsId: 0);

    // final requestBody = ApiRequestDataModel(
    //     apiFor: "change_process",
    //     clientAuthToken: token,
    //     mfgPmpmId: selectedProcessId,
    //     mfgPersonId: widget.empId,
    //     mfgpEmpId: widget.mfgpempid);
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
    final productResponse =
        Provider.of<AllocationProvider>(context, listen: true)
            .User
            ?.allocationEntity;

    // Convert the list to a set to remove duplicates, then back to list
    final ProcessNames = productResponse
            ?.map((process) => process.processname)
            ?.toSet()
            ?.toList() ??
        [];

    return Drawer(backgroundColor: Color.fromARGB(150, 235, 236, 255),
    
      child: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Process :",
              //       style: TextStyle(color: Colors.black, fontSize: 25),
              //     ),
              //     SizedBox(
              //       width: 10,
              //       height: 80,
              //     ),
              //     Expanded(
              //       child: SizedBox(
              //         // Wrap the DropdownButton with a fixed size container
              //         height: 50, // Set a fixed height for the dropdown list
              //         child: Row(
              //           // Use ListView for vertical scrolling
              //           children: [
              //             DropdownButton<String>(
              //               icon: Icon(Icons.arrow_drop_down,
              //                   color: Colors.blue, size: 45),
              //               // Set dropdownColor to transparent to hide dropdown color
              //               // hint: Text(
              //               //   'Select Process',
              //               //   style: TextStyle(
              //               //       color: Colors
              //               //           .black26), // Set dropdown text color to black
              //               // ),
              //               value: selectedItem,
              //               underline: Container(
              //                 height: 2,
              //               ),
              //               onChanged: (String? newValue) {
              //                 setState(() {
              //                   selectedItem = newValue;
              //                   selectedProcessId = productResponse
              //                       ?.firstWhere((process) =>
              //                           process.processname == newValue)
              //                       ?.processid;
              //                 });
              //               },
          
              //               // Redirect to the previous screen
              //               //Navigator.pop(context, newValue);
          
              //               items: ProcessNames?.map((name) {
              //                     return DropdownMenuItem<String>(
              //                       value: name,
              //                       child: Text(name ?? "",
              //                           style: TextStyle(
              //                               color: Colors
              //                                   .black)), // Set dropdown text color to black
              //                     );
              //                   }).toList() ??
              //                   [], // Add toList() to avoid null error
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            
               Text(
                  'Process Area',style: TextStyle(fontSize: 24.sp,
                                    color: Color.fromARGB(255, 80, 96, 203),
                                    fontFamily: "Lexend",
                                    fontWeight: FontWeight.w500),
                  // style: drawerTextColor,
                ),
              SizedBox(height: 20.h,),
          
              Container(
                padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 600.h,
                child: Scrollbar(
                controller: _scrollController,
                radius: Radius.circular(8),
                thickness: 6,
                thumbVisibility: true,
                
                  child: ListView.builder(
                             controller: _scrollController,
                    itemCount: productResponse?.length ?? 0,
                    itemBuilder: (context, index) => GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16.h, ),
                                      decoration:
                                          BoxDecoration( border: Border(
    top: (index == 0)
        ? BorderSide(width: 1, color: Colors.grey.shade500)
        : BorderSide.none,
    bottom: BorderSide(width: 1, color: Colors.grey.shade500),
  ),), // Set unique background color for selected tile
                                      child: Text(
                                       productResponse![index].processname ?? "",
                                        style: TextStyle(color: Colors.black54,
                                    fontFamily: "Lexend",
                                    fontSize: 15.sp),
                                      ),
                                    ),
                                  ),
                                      onTap: () async {
                        final processId =
                            productResponse[index].processid ?? 0;
                        if (processId != null) {
                          setState(() {
                            selectedProcessId = productResponse
                                ?.firstWhere((process) =>
                                    process.processid == processId)
                                ?.processid;
                          });
                            
                          await sendProcess();
                            
                          await employeeApiService.employeeList(
                              context: context,
                              processid: widget.processid!,
                              deptid: widget.deptid ?? 1,
                              psid: widget.psid ?? 0);

                                   await listofworkstationService
            .getListofWorkstation(
                context: context,
                deptid: widget.deptid ?? 1057,
                psid: widget.psid ?? 0,
                processid:
                   widget.processid?? 0);
    
      await attendanceCountService.getAttCount(
            context: context,
            id: widget.processid ?? 0,
            deptid: widget.deptid ?? 0,
            psid: widget.psid ?? 0);
                            
                          Navigator.of(context).pop();
                        }
                      },),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 200,
              //   width: 500,
              // ),
          
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 150),
              //       child: ElevatedButton(
              //         style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all<Color>(Colors.blue),
              //         ),
              //         autofocus: true,
              //         onPressed: () async{
          
              //             await sendProcess();
              //              await  employeeApiService.employeeList(
              //                   context: context, id: widget.processid!);
          
              //               Navigator.of(context).pop();
          
              //         },
              //         child: const Text(
              //           'Ok',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 15,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
