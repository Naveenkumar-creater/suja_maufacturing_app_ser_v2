import 'package:flutter/material.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_home_shiftstatus_widget.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_processqty_widget.dart';
import 'package:prominous/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/process_qty_widget.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/shift_status_widget.dart';
import 'package:provider/provider.dart';


import '../../features/presentation_layer/provider/employee_provider.dart';
import '../../features/presentation_layer/widget/homepage_widget/employee_details_list.dart';
import '../../features/presentation_layer/widget/homepage_widget/product_list_qty.dart';
import '../../features/presentation_layer/widget/my_box.dart';
import '../../features/presentation_layer/widget/my_tile.dart';
import '../../features/presentation_layer/widget/homepage_widget/mydrawer.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  late Stream<String> current;
  @override
  void initState() {
    current = Stream<String>.periodic(Duration(seconds: 1), (i) {
      final DateTime now = DateTime.now();
      return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}  ${now.hour}: ${now.minute}:${now.second.toString().padLeft(2, '0')}';
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProcessProvider>(context, listen:true).user;
 
    // final processName = user?.listofProcessEntity?.first.processName;

    // final processname =  Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processName ?? user?.listofProcessEntity?.first?.processName;

final processname =  Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.isNotEmpty ?? false
  ? Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processName ?? "Default"
  : "Default";

    // final processId = Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processId ?? user?.listofProcessEntity?.first.processId;

    final processId = Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.isNotEmpty ?? false
  ? Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processId ?? 1
  : 1;
  
    final deptid = user?.listofProcessEntity?.first.deptId ?? 1;
    final shiftgroupId = user?.listofProcessEntity?.first.shiftgroupId ?? 1;


        final totalemployee =
        Provider.of<AttendanceCountProvider>(context, listen: true)
            .user
            ?.attendanceEntity
            ?.totalEmployees;

    final presentees =
        Provider.of<AttendanceCountProvider>(context, listen: true)
            .user
            ?.attendanceEntity
            ?.presentees;

   final shiftstatus = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftStatus ?? 0;


       final psId = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psId ?? 0;

        print(psId);

        
        // final mpmid = Provider.of<ShiftStatusProvider>(context, listen: true)
        // .user
        // ?.shiftStatusdetailEntity
        // ?.psMpmId ?? 0;

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          '${processname == null ? "" : processname } ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 45, 54, 104),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // backgroundColor: defaultBackgroundColor,
      //appBar: myAppBar,
      drawer: MyDrawer(
          //emp_mgr: emp_mgr!,
          ),
          
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mobile_scaffold.jpg'),
                fit: BoxFit.cover, // Adjust as needed
              ),
            ),
          ),
          SizedBox(
                      height: 5,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:25.0,left: 15,right: 15),
                      child: Column(
                        children: [
                      
                              MobileShitStatusWidget(deptid:deptid , processid: processId,shiftgroupid:shiftgroupId, psid: psId,),
                              SizedBox(height: 10,),

                               MobileProcessQtyWidget(id: processId,psid:psId),
SizedBox(height: 10,),
                                 shiftstatus!= 0  
                                    ? EmployeeDetailsList(
                                      
                                        // id: mpmid, 
                                        // shiftid: shitid,
                                        deptid: deptid,
                                         psid:psId
                                      )
                                    : SizedBox(),
                        ],
                      ),
                    )

        ],
      ));
  }
}
