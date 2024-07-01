import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_emp_details_widget.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_home_shiftstatus_widget.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_mydrawer.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_processqty_widget.dart';
import 'package:prominous/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/employee_details_list.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/mydrawer.dart';
import 'package:provider/provider.dart';
import '../../features/presentation_layer/provider/employee_provider.dart';

class MobileScaffold extends StatefulWidget {
  const   MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProcessProvider>(context, listen: true).user;
    final processname = Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.isNotEmpty ?? false
        ? Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processName ?? "Default"
        : "Default";

    final processId = Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.isNotEmpty ?? false
        ? Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processId ?? 1
        : 1;

    final deptid = user?.listofProcessEntity?.first.deptId ?? 1;
    final shiftgroupId = user?.listofProcessEntity?.first.shiftgroupId ?? 1;
    final totalemployee = Provider.of<AttendanceCountProvider>(context, listen: true)
            .user
            ?.attendanceEntity
            ?.totalEmployees;

    final presentees = Provider.of<AttendanceCountProvider>(context, listen: true)
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

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      drawer: MobileMyDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white        ,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 60.0), // Adjust top padding as needed
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: SvgPicture.asset(
                  'assets/svg/drawer.svg',
                  color: Color.fromARGB(255, 80, 96, 203),
                  width: 36,
                ),
              ),
              SizedBox(width: 15,),
              Text(
                processname,
                style: TextStyle(
                  color: Color.fromARGB(255, 80, 96, 203),
                  fontSize: 24.0,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 36), // Placeholder to balance the drawer icon width
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
           
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white
              // image: DecorationImage(
              //   image: AssetImage('assets/images/mobile_scaffold.jpg'),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
           processname!="Default"?
          Padding(
            padding: const EdgeInsets.only(top: 25.0,),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MobileShitStatusWidget(
                  deptid: deptid,
                  processid: processId,
                  shiftgroupid: shiftgroupId,
                  psid: psId,
                ),
                
                MobileProcessQtyWidget(id: processId, psid: psId),
             Padding(
               padding: const EdgeInsets.only(left: 8.0,right: 8),
               child: Text(
                  "Employee Details",
                  style: TextStyle(
                    color: Color.fromARGB(255, 80, 96, 203),
                    fontSize: 20.0,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),),
             ),SizedBox(height: 8,),
                shiftstatus != 0
                    ? MobileEmployeeDetailsList(
                        deptid: deptid,
                        psid: psId,
                      )
                    : SizedBox(
                      
                    ),
              ],
            ),
          ):

       Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Center(child: Text(" 'Start by Choosing a Process Area' ",style: TextStyle(color:Colors.black,fontSize: 18,fontFamily: "Lexend"),)),
         ],
       )
        ],
      ),
    );
  }
}
