import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:suja/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:suja/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:suja/features/presentation_layer/api_services/process_di.dart';
import 'package:suja/features/presentation_layer/provider/actual_qty_provider.dart';
import 'package:suja/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:suja/features/presentation_layer/provider/employee_provider.dart';
import 'package:suja/features/presentation_layer/widget/homepage_widget/process_qty_widget.dart';

import '../../features/presentation_layer/provider/process_provider.dart';
import '../../features/presentation_layer/widget/doughnut_chart.dart';
import '../../features/presentation_layer/widget/homepage_widget/employee_details_list.dart';
import '../../features/presentation_layer/widget/homepage_widget/employee_details_table.dart';
import '../../features/presentation_layer/widget/homepage_widget/mydrawer.dart';
import '../../features/presentation_layer/widget/homepage_widget/product_list_qty.dart';
import '../../features/presentation_layer/widget/homepage_widget/side_drawer.dart';


class ResponsiveTabletHomepage extends StatefulWidget {
  const ResponsiveTabletHomepage({Key? key}) : super(key: key);

  @override
  State<ResponsiveTabletHomepage> createState() =>
      _ResponsiveTabletHomepageState();
}

class _ResponsiveTabletHomepageState extends State<ResponsiveTabletHomepage> {
  late Stream<String> current;
    ProcessApiService processApiService = ProcessApiService();
    AttendanceCountService attendanceCountService=AttendanceCountService();
  bool isLoading =false;

  @override
  void initState() {
    super.initState();
     final user = Provider.of<ProcessProvider>(context, listen: false).user;
 
    // final processid = user?.listofProcessEntity?.isNotEmpty ?? false
    //     ? user!.listofProcessEntity!.first.processId
    //     : null;
    final processName = user?.listofProcessEntity?.first.processName;
    
    final processid = user?.listofProcessEntity?.first.processId ?? 1;
    attendanceCountService.getAttCount(context: context, id: processid);

    // currentTime =
    //     '${now.day}-${now.month}-${now.year}  ${now.hour}: ${now.minute}';
    
    current = Stream<String>.periodic(Duration(seconds: 1), (i) {
      final DateTime now = DateTime.now();
      return '${now.day}-${now.month}-${now.year}  ${now.hour}: ${now.minute}:${now.second.toString().padLeft(2, '0')}';
    });
  }


  @override
  Widget build(BuildContext context) {
    // final processid = Provider.of<ProcessProvider>(context, listen: true)
    //     .user
    //     ?.listofProcessEntity
    //     ?.first
    //     .processId;


    final user = Provider.of<ProcessProvider>(context, listen: true).user;
 
    // final processid = user?.listofProcessEntity?.isNotEmpty ?? false
    //     ? user!.listofProcessEntity!.first.processId
    //     : null;
    final processName = user?.listofProcessEntity?.first.processName;
final processname = Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.isNotEmpty ?? false
  ? Provider.of<EmployeeProvider>(context, listen: true).user?.listofEmployeeEntity?.first.processName ?? "Default"
  : "Default";
    final processid = user?.listofProcessEntity?.first.processId ?? 1;
    final shitid =  user?.listofProcessEntity?.first.shiftid ?? 1;
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

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: defaultBackgroundColor,

      body: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Container(width: size.width,
        height: size.height,
          child: Padding(
            padding: const EdgeInsets.only(top:32,left: 8,right: 8,bottom: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: MyDrawer(),
                     width: 250,
                  height: 710,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            height: 710,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              
                                              children: [
                                                Expanded(
                                                  child: Container( height: 76,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Text("${processname}",
                                                            style: const TextStyle(
                                                                fontSize: 28,
                                                                color:
                                                                    Colors.blue)),
                                                                    Text('Shift 1',style:TextStyle(fontSize: 17,color: Colors.black54))
                                                       
                                                      ],
                                                    ),
                                                  ),
                                                ), SizedBox(
                                                    width: 8,
                                                  ),
                                                Expanded(
                                                  child: Container(
                                                    width: 400,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          // Stack(
                                                          //   alignment:
                                                          //       Alignment.center,
                                                          //   children: [
                                                          //     Text('80%'),
                                                          //     SizedBox(
                                                          //       width: 100,
                                                          //       child:
                                                          //           CircularPercentIndicator(
                                                          //         animation: true,
                                                          //         animationDuration:
                                                          //             2000,
                                                          //         radius: 40,
                                                          //         lineWidth: 8,
                                                          //         percent: 0.8,
                                                          //         progressColor:
                                                          //             Colors
                                                          //                 .deepPurple,
                                                          //         backgroundColor:
                                                          //             Colors
                                                          //                 .deepPurple
                                                          //                 .shade200,
                                                          //         circularStrokeCap:
                                                          //             CircularStrokeCap
                                                          //                 .round,
                                                          //       ),
                                                          //     ),
                                                          //   ],
                                                          // ),
                                                          Container(height: 60,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Attendance",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize: 20),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  "${presentees}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .deepPurple,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: 14),
                                                                ),
                                                                Text(
                                                                  "/",
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              179,
                                                                              157,
                                                                              219),
                                                                      fontSize: 14),
                                                                ),
                                                                Text(
                                                                  "${totalemployee}",
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              179,
                                                                              157,
                                                                              219),
                                                                      fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),SizedBox(width: 8,),
                                                Container( height: 74,width: 490,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                     
                                                      StreamBuilder<String>(
                                                        stream: current,
                                                        builder:
                                                            (context, snapshot) {
                                                          if (snapshot.hasData) {
                                                            return Text(
                                                              '${snapshot.data}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.w400,
                                                                  fontSize: 20,
                                                                  color:Colors.black54),
                                                            );
                                                          } else
                                                            return Text(
                                                              'Loading',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black54),
                                                            );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),

                                            ProcessQtyWidget(id: processid,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // EmployeeDetailsTable(),
                                // EmployeeDetailsTable();
                                processid != null
                                    ? EmployeeDetailsList(
                                        id: processid, shiftid: shitid,
                                      )
                                    : SizedBox(), // Or any other fallback widget
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
