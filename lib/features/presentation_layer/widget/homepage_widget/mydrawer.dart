import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';

import 'package:prominous/features/presentation_layer/api_services/login_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/process_di.dart';
import 'package:prominous/features/presentation_layer/api_services/shift_status_di.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/shift_status_widget.dart';

import '../../api_services/employee_di.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  static late String? processName;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  ProcessApiService processApiService = ProcessApiService();
  EmployeeApiService employeeApiService = EmployeeApiService();
  LoginApiService logout = LoginApiService();
  final ActualQtyService actualQtyService = ActualQtyService();
  AttendanceCountService attendanceCountService = AttendanceCountService();
  PlanQtyService planQtyService = PlanQtyService();
  ShiftStatusService shiftStatusService = ShiftStatusService();

  bool isLoading = false;
  bool isFetching = false;
  DateTime? lastTapTime;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getProcess();
  }

  Future<void> getProcess() async {
    try {
      await processApiService.getProcessdetail(
        context: context,
      );
      setState(() {
        isLoading = true; // Set isLoading to false when data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
  }

  int? _selectedIndex; // State variable to store the selected index
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String toDate = DateFormat('dd-MM-yyyy ').format(now);
    String toTime = DateFormat(' HH:mm:ss').format(now);

    final processList =
        Provider.of<ProcessProvider>(context).user?.listofProcessEntity;
    final userName = Provider.of<LoginProvider>(context).user!.loginId;

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.grey[200],
      elevation: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hello,',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    Text(
                      '$userName',
                      style:
                          const TextStyle(fontSize: 24, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                'PROCESS AREA ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 400,
              child: Scrollbar(
                controller: _scrollController,
                radius: Radius.circular(8),
                thickness: 8,
                thumbVisibility: true,
                child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: processList?.length ?? 0,
                    itemBuilder: (context, index) => GestureDetector(
                      child: Container(
                            padding: EdgeInsets.only(bottom: 12, top: 12, left: 16),
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Colors.blue.withOpacity(0.3)
                                  : null,
                            ), // Set unique background color for selected tile
                            child: Text(
                              processList![index].processName ?? "",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                      onTap: () async {
                        setState(() {
                          _selectedIndex = index; // Update selected index
                        });
                        final processId = processList[index].processId ?? 0;
                        final deptId = processList[index].deptId ?? 0;
                        try {
                          // Perform shiftStatusService first
                          await shiftStatusService.getShiftStatus(
                              context: context,
                              deptid: deptId,
                              processid: processId);
                          final psId = Provider.of<ShiftStatusProvider>(context,
                                      listen: false)
                                  .user
                                  ?.shiftStatusdetailEntity
                                  ?.psId ??
                              0;

                          // Perform employeeApiService next
                          await employeeApiService.employeeList(
                              context: context,
                              processid: processId,
                              deptid: deptId,
                              psid: psId);

                          // Continue with other asynchronous operations sequentially
                          await attendanceCountService.getAttCount(
                              context: context, id: processId, deptid: deptId, psid: psId);

                          await actualQtyService.getActualQty(
                              context: context, id: processId,psid: psId);

                          await planQtyService.getPlanQty(
                              context: context, id: processId, psid: psId);
                        } catch (e) {
                          // Handle any errors that occur during the async operations
                          print('Error fetching data: $e');
                        }
                      },
                    )),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text(
                'LOGOUT',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                logout.logOutUser(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
