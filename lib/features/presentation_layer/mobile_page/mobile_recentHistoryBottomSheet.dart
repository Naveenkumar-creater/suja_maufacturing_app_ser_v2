import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/delete_production_entry.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/presentation_layer/api_services/activity_di.dart';
import 'package:prominous/features/presentation_layer/api_services/emp_production_entry_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/api_services/product_di.dart';
import 'package:prominous/features/presentation_layer/api_services/recent_activity.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_edit_entry.dart';
import 'package:prominous/features/presentation_layer/provider/product_provider.dart';
import 'package:prominous/features/presentation_layer/provider/recent_activity_provider.dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/edit_emp_production_details..dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentHistoryBottomSheet extends StatefulWidget {
  final int? empid;
  final int? processid;
  final String? barcode;
  final int? cardno;
  final int? assetid;
  final int? deptid;
  bool? isload;
  final int? psid;
  final int? attendceStatus;
  final String? attenceid;

  RecentHistoryBottomSheet(
      {Key? key,
      this.empid,
      this.processid,
      this.barcode,
      this.cardno,
      this.assetid,
      this.isload,
      this.deptid,
      this.psid,
      this.attenceid,
      this.attendceStatus})
      : super(key: key);

  @override
  State<RecentHistoryBottomSheet> createState() =>
      _RecentHistoryBottomSheetState();
}

class _RecentHistoryBottomSheetState extends State<RecentHistoryBottomSheet> {
  final ProductApiService productApiService = ProductApiService();
  final RecentActivityService recentActivityService = RecentActivityService();
  EmpProductionEntryService empProductionEntryService =
      EmpProductionEntryService();
  EmployeeApiService employeeApiService = EmployeeApiService();

  // Future<void> _fetchARecentActivity() async {
  //   try {
  //     // Fetch data
  //     await empProductionEntryService.productionentry(
  //         context: context,
  //         id: widget.empid ?? 0,
  //         deptid: widget.deptid ?? 0,
  //         psid: widget.psid ?? 0);



  //     await recentActivityService.getRecentActivity(
  //         context: context,
  //         id: widget.empid ?? 0,
  //         deptid: widget.deptid ?? 0,
  //         psid: widget.psid ?? 0);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  delete({
    int? ipdid,
    int? ipdpsid,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    final requestBody = DeleteProductionEntryModel(
        apiFor: "delete_entry",
        clientAuthToken: token,
        ipdid: ipdid,
        ipdpsid: ipdpsid);
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

  void deletePop(BuildContext context, ipdid, ipdpsid) {
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
                                await delete(
                                    ipdid: ipdid ?? 0, ipdpsid: ipdpsid ?? 0);
                                   await recentActivityService.getRecentActivity(
          context: context,
          id: widget.empid ?? 0,
          deptid: widget.deptid ?? 0,
          psid: widget.psid ?? 0);
              await empProductionEntryService.productionentry(
          context: context,
          pwsId: widget.empid ?? 0,
          deptid: widget.deptid ?? 0,
          psid: widget.psid ?? 0);
                            
                                Navigator.of(context).pop();
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
    final recentActivity =
        Provider.of<RecentActivityProvider>(context, listen: false)
            .user
            ?.recentActivitesEntityList;

    final productname = Provider.of<ProductProvider>(context, listen: false)
        .user
        ?.listofProductEntity;
    return Container(
      width: double.infinity,
      height: 600,
      child: (recentActivity != null && recentActivity.isNotEmpty)
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: recentActivity?.length,
              itemBuilder: (context, index) {
                final data = recentActivity?[index];
          
                return  Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15 ,top: 10,),
                  child: Container(
                                        width: 300,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 229, 234, 254),
                                          borderRadius: BorderRadius.circular(22),
                                          border:
                    Border.all(width: 1, color: Colors.grey.shade100),
                                        ),
                    child: Padding(
                       padding: const EdgeInsets.only(left: 20, right: 20,top: 4,bottom: 4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(22),
                                      color: Color.fromARGB(
                                          255, 80, 96, 203),
                                    ),
                                    child: Text('${index + 1}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'Lexend')),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                      '${(data?.ipditemid != 0 ? productname?.firstWhere(
                                            (product) =>
                                                data?.ipditemid ==
                                                product.productid,
                                          ).productName : " ")}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 80, 96, 203),
                                          fontFamily: 'Lexend')),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MobileEditEmpProductionEntryPage(
                                          deptid: data?.deptid ?? 1057,
                                          empid: data?.ipdempid ?? 0,
                                          isload: true,
                                          processid:
                                              data?.processid ?? 0,
                                          psid: data?.ipdpsid,
                                          ipdid: data?.ipdid,
                                          attenceid: widget.attenceid,
                                          attendceStatus:
                                              widget.attendceStatus,
                                        ),
                                      ));
                                },            
                  icon: Icon(Icons.edit_sharp, color: Color.fromARGB(255, 80, 96, 203))
                  
                  
                  
                   ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ' ${data?.ipdtotime ?? ''}  ',
                                
                              style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: 'Lexend')),
                              if (index == 0)
                           
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: IconButton(
                                        onPressed: () async {
                                          // updateproduction(widget.processid);
                                          deletePop(context, data?.ipdid ?? 0,
                                              data?.ipdpsid ?? 0);
                                        },
                                        icon: SvgPicture.asset(
                    'assets/svg/trash.svg',
                    color: Colors.red,
                    width:30 ,
                  ),
                                        
                                      
                                      ),
                                    ),
                                  ],
                                ),
                              if (index != 0) 
                              SizedBox(height: 30,

                                
                                child: Text("")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })

          // ? Column(
          //     children: [
          //       Container(
          //         height: 55,
          //         width: double.infinity,
          //         decoration: const BoxDecoration(
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(8),
          //                 topRight: Radius.circular(8)),
          //             color: Color.fromARGB(
          //                 255, 45, 54, 104)),
          //         child: Row(
          //           mainAxisAlignment:
          //               MainAxisAlignment.center,
          //           children: [
          //             Container(
          //               alignment: Alignment.centerLeft,
          //               width: 100,
          //               child: Text('S.NO',
          //                   style: TextStyle(
          //                       color: Colors.white)),
          //             ),
          //             Container(
          //               alignment: Alignment.center,
          //               width: 150,
          //               child: Text('Prev Time',
          //                   style: TextStyle(
          //                       color: Colors.white)),
          //             ),
          //             Container(
          //               alignment: Alignment.center,
          //               width: 150,
          //               child: Text('Product Name',
          //                   style: TextStyle(
          //                       color: Colors.white)),
          //             ),
          //             // Container(
          //             //   alignment: Alignment.center,
          //             //   width: 150,
          //             //   child: Text('Good Qty',
          //             //       style: TextStyle(
          //             //           color: Colors.white)),
          //             // ),
          //             // Container(
          //             //   alignment: Alignment.center,
          //             //   width: 150,
          //             //   child: Text('Rejected Qty',
          //             //       style: TextStyle(
          //             //           color: Colors.white)),
          //             // ),
          //             // Container(
          //             //   alignment: Alignment.center,
          //             //   width: 150,
          //             //   child: Text('Rework ',
          //             //       style: TextStyle(
          //             //           color: Colors.white)),
          //             // ),
          //             Container(
          //               alignment: Alignment.center,
          //               width: 10,
          //               child: Text('Edit Entries',
          //                   style: TextStyle(
          //                       color: Colors.white)),
          //             ),
          //             Container(
          //               alignment: Alignment.center,
          //               width: 20,
          //               child: Text('Delete Entry',
          //                   style: TextStyle(
          //                       color: Colors.white)),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Container(
          //         decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.only(
          //                 bottomLeft:
          //                     Radius.circular(8),
          //                 bottomRight:
          //                     Radius.circular(8))),
          //         width: double.infinity,
          //         height: 50,
          //         child: ListView.builder(
          //           shrinkWrap: true,
          //           itemCount: recentActivity?.length,
          //           itemBuilder: (context, index) {
          //             final data =
          //                 recentActivity?[index];
          //             return Container(
          //               decoration: BoxDecoration(
          //                 border: Border(
          //                   bottom: BorderSide(
          //                       width: 1,
          //                       color: Colors
          //                           .grey.shade300),
          //                 ),
          //                 color: index % 2 == 0
          //                     ? Colors.grey.shade50
          //                     : Colors.grey.shade100,
          //               ),
          //               height: 80,
          //               width: double.infinity,
          //               child: Row(
          //                 mainAxisAlignment:
          //                     MainAxisAlignment.center,
          //                 children: [
          //                   Container(
          //                     alignment:
          //                         Alignment.centerLeft,
          //                     width: 100,
          //                     child: Text(
          //                       ' ${index + 1}  ',
          //                       style: TextStyle(
          //                           color: Colors
          //                               .grey.shade900),
          //                     ),
          //                   ),
          //                   // Container(
          //                   //   alignment:
          //                   //       Alignment.centerRight,
          //                   //   width: 150,
          //                   //   child: Padding(
          //                   //     padding:
          //                   //         const EdgeInsets
          //                   //             .only(left: 35),
          //                   //     child: Text(
          //                   //       ' ${data?.ipdtotime ?? ''}  ',
          //                   //       style: TextStyle(
          //                   //           color: Colors.grey
          //                   //               .shade900),
          //                   //     ),
          //                   //   ),
          //                   // ),
          //                   Container(
          //                     alignment:
          //                         Alignment.center,
          //                     width: 150,
          //                     child: Text(
          //                       '${(data?.ipditemid != 0 ? productname?.firstWhere(
          //                             (product) =>
          //                                 data?.ipditemid ==
          //                                 product
          //                                     .productid,
          //                           ).productName : " ")}',
          //                       style: TextStyle(
          //                           color: Colors
          //                               .grey.shade900),
          //                     ),
          //                   ),
          //                   Container(
          //                     alignment:
          //                         Alignment.center,
          //                     width: 150,
          //                     child: Text(
          //                       '  ${data?.ipdgoodqty ?? ''} ',
          //                       style: TextStyle(
          //                           color: Colors
          //                               .grey.shade900),
          //                     ),
          //                   ),
          //                   // Container(
          //                   //   alignment:
          //                   //       Alignment.center,
          //                   //   width: 150,
          //                   //   child: Text(
          //                   //     '  ${data?.ipdrejqty ?? ''}',
          //                   //     style: TextStyle(
          //                   //         color: Colors
          //                   //             .grey.shade900),
          //                   //   ),
          //                   // ),
          //                   // Container(
          //                   //   alignment:
          //                   //       Alignment.center,
          //                   //   width: 150,
          //                   //   child: Text(
          //                   //     '  ${data?.ipdreworkflag == 0 ? 'NO' : "Yes"} ',
          //                   //     style: TextStyle(
          //                   //         color: Colors
          //                   //             .grey.shade900),
          //                   //   ),
          //                   // ),
          //                   Container(
          //                     alignment:
          //                         Alignment.center,
          //                     width: 150,
          //                     child: IconButton(
          //                       onPressed: () {
          //                         Navigator.push(
          //                             context,
          //                             MaterialPageRoute(
          //                               builder:
          //                                   (context) =>
          //                                       EditEmpProductionEntryPage(
          //                                 deptid:
          //                                     data?.deptid ??
          //                                         1057,
          //                                 empid:
          //                                     data?.ipdempid ??
          //                                         0,
          //                                 isload: true,
          //                                 processid:
          //                                     data?.processid ??
          //                                         0,
          //                                 psid: data
          //                                     ?.ipdpsid,
          //                                 ipdid: data
          //                                     ?.ipdid,
          //                                 attenceid: widget
          //                                     .attenceid,
          //                                 attendceStatus:
          //                                     widget
          //                                         .attendceStatus,
          //                               ),
          //                             ));
          //                       },
          //                       icon: const Icon(
          //                           Icons
          //                               .mode_edit_outline_outlined,
          //                           size: 25,
          //                           color: Colors.blue),
          //                     ),
          //                   ),
          //                   if (index == 0)
          //                     Container(
          //                       alignment:
          //                           Alignment.center,
          //                       width: 150,
          //                       child: IconButton(
          //                         onPressed: () async {
          //                           // updateproduction(widget.processid);
          //                           deletePop(
          //                               context,
          //                               data?.ipdid ??
          //                                   0,
          //                               data?.ipdpsid ??
          //                                   0);
          //                         },
          //                         icon: const Icon(
          //                             Icons.delete,
          //                             size: 25,
          //                             color:
          //                                 Colors.red),
          //                       ),
          //                     ),
          //                   if (index != 0)
          //                     Container(
          //                         alignment:
          //                             Alignment.center,
          //                         width: 150,
          //                         child: Text("")),
          //                 ],
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   )
          : Center(
              child: Text("No data available"),
            ),
    );
  }
}
