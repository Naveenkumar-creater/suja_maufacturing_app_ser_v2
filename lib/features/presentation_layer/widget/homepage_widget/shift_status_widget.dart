import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja/constant/request_data_model/shift_status_model.dart';
import 'package:suja/constant/show_pop_error.dart';
import 'package:suja/features/data/core/api_constant.dart';
import 'package:suja/features/presentation_layer/api_services/employee_di.dart';
import 'package:suja/features/presentation_layer/api_services/shift_status_di.dart';
import 'package:suja/features/presentation_layer/provider/shift_status_provider.dart';

class ShitStatusWidget extends StatefulWidget {
  final int? deptid;
  final int? processid;
  final int? shiftgroupid;
  final int? psid;
  const ShitStatusWidget(
      {super.key,
      required this.deptid,
      required this.processid,
      this.shiftgroupid,
      required this.psid});

  @override
  State<ShitStatusWidget> createState() => _ProcessQtyWidgetState();
}

class _ProcessQtyWidgetState extends State<ShitStatusWidget> {
  late Stream<String> current;

  ShiftStatusService shiftStatusService = ShiftStatusService();
  EmployeeApiService employeeApiService = EmployeeApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // _fetchActualQty();
    current = Stream<String>.periodic(Duration(seconds: 1), (i) {
      final DateTime now = DateTime.now();
      return '${now.day}-${now.month}-${now.year}  ${now.hour}: ${now.minute}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  // Future<void> _fetchActualQty() async {
  //   try {
  //     await shiftStatusService.getShiftStatus(
  //         context: context, deptid: widget.deptid, processid: widget.processid);
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

  Future<void> openShift() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";

    final requestBody = ShiftStatusreqModel(
        apiFor: "update_shift_status",
        clientAuthToken: token,
        deptId: widget.deptid,
        processId: widget.processid,
        psid: 0,
        shiftgroupId: widget.shiftgroupid);
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
    final ShiftStatus = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftStatus;
    final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    //  int? achivedProduct=;

    return Container(
      height: 74,
      width: 490,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder<String>(
            stream: current,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.black54),
                );
              } else
                return Text(
                  'Loading',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                );
            },
          ),
          SizedBox(
            width: 10,
          ),
          ShiftStatus == 1
              ? Text('Shift Id:${Shiftid}',
                  style: TextStyle(fontSize: 17, color: Colors.black54))
              : Text('No Shift',
                  style: TextStyle(fontSize: 17, color: Colors.black54)),
          SizedBox(
            width: 10,
          ),
          ShiftStatus == 1
              ? ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {},
                  child: Text('Close Shift'))
              : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Indicate loading
                    });

                    try {
                      // Perform all asynchronous operations
                      await openShift();
                      await shiftStatusService.getShiftStatus(
                          context: context,
                          deptid: widget.deptid,
                          processid: widget.processid);
                      await employeeApiService.employeeList(
                          context: context,
                          deptid: widget.deptid ?? 1,
                          processid: widget.processid ?? 0,
                          psid: widget.psid ?? 0);
                    } catch (e) {
                      // Handle any errors that occur during the async operations
                      print('Error: $e');
                    } finally {
                      setState(() {
                        isLoading = false; // Indicate completion
                        // Update any other state variables as needed
                      });
                    }
                  },
                  child: Text('Open Shift'),
                )
        ],
      ),
    );
  }
}
