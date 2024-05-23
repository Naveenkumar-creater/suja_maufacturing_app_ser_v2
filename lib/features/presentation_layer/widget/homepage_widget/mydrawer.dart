import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suja/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:suja/features/presentation_layer/api_services/attendace_count_di.dart';

import 'package:suja/features/presentation_layer/api_services/login_di.dart';
import 'package:suja/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:suja/features/presentation_layer/api_services/process_di.dart';
import 'package:suja/features/presentation_layer/api_services/shift_status_di.dart';
import 'package:suja/features/presentation_layer/provider/login_provider.dart';
import 'package:suja/features/presentation_layer/provider/process_provider.dart';
import 'package:suja/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:suja/features/presentation_layer/widget/homepage_widget/shift_status_widget.dart';

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
  final ActualQtyService actualQtyService =ActualQtyService();
  AttendanceCountService attendanceCountService=AttendanceCountService();
  PlanQtyService planQtyService =PlanQtyService();
  ShiftStatusService shiftStatusService = ShiftStatusService();

 bool isLoading = false;
  bool isFetching = false;
  DateTime? lastTapTime;

  @override
  void initState() {
    super.initState();
    getProcess();
   
  }

    Future<void> getProcess() async {
    try {
      await  processApiService.getProcessdetail(
      context: context,
    );;
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
      backgroundColor: Colors.grey[300],
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
                    color: Colors.grey.shade200,
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
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                // style: drawerTextColor,
              ),
            ),
            Stack(
              children: [
               
               Container(
  width: double.infinity,
  height: 260,
  child: Scrollbar(radius: Radius.circular(8),thickness: 10,interactive: true,
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: processList?.length ?? 0,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(
            processList![index].processName ?? "",
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () async {
            final processId = processList[index].processId ?? 0;
            final deptId = processList[index].deptId ?? 0;
              try {
                // Perform shiftStatusService first
                await shiftStatusService.getShiftStatus(context: context, deptid: deptId, processid: processId);
     final psId = Provider.of<ShiftStatusProvider>(context, listen:false )
          .user
          ?.shiftStatusdetailEntity
          ?.psId ?? 0;
       
                // Perform employeeApiService next
                await employeeApiService.employeeList(context: context, processid: processId, deptid: deptId, psid: psId);
                
    
                // Continue with other asynchronous operations sequentially
                 await attendanceCountService.getAttCount(context: context, id: processId);

                await actualQtyService.getActualQty(context: context, id: processId);
               
                await planQtyService.getPlanQty(context: context, id: processId);
              } catch (e) {
                // Handle any errors that occur during the async operations
                print('Error fetching data: $e');
              } 
            
          },
        ),
      ),
    ),
  ),
),

                 Padding(
                  padding: const EdgeInsets.only(left: 190, top: 200),
                  child: Icon(
                    Icons.arrow_drop_down,size: 45,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black54,
              ),
              title: const Text(
                'LOGOUT',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
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