// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import 'package:prominous/constant/request_data_model/delete_production_entry.dart';
// import 'package:prominous/constant/responsive/tablet_body.dart';
// import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
// import 'package:prominous/features/data/model/activity_model.dart';
// import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/edit_emp_production_details..dart';
// import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_close_shift_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:prominous/constant/lottieLoadingAnimation.dart';

// import 'package:prominous/constant/request_data_model/productuion_entry_model.dart';
// import 'package:prominous/features/presentation_layer/api_services/activity_di.dart';
// import 'package:prominous/features/presentation_layer/api_services/emp_production_entry_di.dart';
// import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
// import 'package:prominous/features/presentation_layer/api_services/recent_activity.dart';
// import 'package:prominous/features/presentation_layer/api_services/target_qty_di.dart';
// import 'package:prominous/features/presentation_layer/provider/activity_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/asset_barcode_provier.dart';
// import 'package:prominous/features/presentation_layer/provider/card_no_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/emp_production_entry_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/product_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/recent_activity_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/target_qty_provider.dart';
// import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_asset_barcode_scan.dart';
// import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_cardno_barcode_scanner.dart';
// import '../../api_services/product_di.dart';
// import '../production_quanties/emp_production_time.dart';
// import 'package:intl/intl.dart';
// import '../../../../constant/show_pop_error.dart';
// import '../../../data/core/api_constant.dart';
// import '../../../../constant/utilities/customnum_field.dart';

// class EmpProductionEntryPage extends StatefulWidget {
//   final int? empid;
//   final int? processid;
//   final String? barcode;
//   final int? cardno;
//   final int? assetid;
//   final int? deptid;
//   bool? isload;
//   final int? psid;
//   final int? attendceStatus;
//   final String? attenceid;

//   EmpProductionEntryPage(
//       {Key? key,
//       this.empid,
//       this.processid,
//       this.barcode,
//       this.cardno,
//       this.assetid,
//       this.isload,
//       this.deptid,
//       this.psid,
//       this.attenceid,
//       this.attendceStatus})
//       : super(key: key);

//   @override
//   State<EmpProductionEntryPage> createState() => _EmpProductionEntryPageState();
// }

// class _EmpProductionEntryPageState extends State<EmpProductionEntryPage> {
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   final TextEditingController goodQController = TextEditingController();
//   final TextEditingController rejectedQController = TextEditingController();
//   final TextEditingController reworkQController = TextEditingController();
//   final TextEditingController targetQtyController = TextEditingController();
//   final TextEditingController batchNOController = TextEditingController();
//   final TextEditingController cardNoController = TextEditingController();
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController assetCotroller = TextEditingController();
//   final ProductApiService productApiService = ProductApiService();
//   final RecentActivityService recentActivityService = RecentActivityService();
//   final ActivityService activityService = ActivityService();
//   final TargetQtyApiService targetQtyApiService = TargetQtyApiService();

//   bool isChecked = false;

//   bool isLoading = true;
//   late DateTime now;
//   late int currentYear;
//   late int currentMonth;
//   late int currentDay;
//   late int currentHour;
//   late int currentMinute;
//   late String currentTime;
//   late int currentSecond;
//   bool visible = true;
//   String? selectedName;
//   int? product_Id;

//   TimeOfDay timeofDay = TimeOfDay.now();
//   late DateTime currentDateTime;
//   // Initialized to avoid null check

//   List<Map<String, dynamic>> submittedDataList = [];

//   String? dropdownProduct;
//   String? activityDropdown;
//   String? lastUpdatedTime;
//   String? currentDate;
//   int? reworkValue;
//   int? productid;
//   int? activityid;
//   TimeOfDay? updateTimeManually;
//   String? cardNo;
//   String? productName;
//   String? assetID;
//   String? achivedTargetQty;

//   EmpProductionEntryService empProductionEntryService =
//       EmpProductionEntryService();

//   EmployeeApiService employeeApiService = EmployeeApiService();

//   Future<void> updateproduction(int? processid) async {
//     final responsedata =
//         Provider.of<EmpProductionEntryProvider>(context, listen: false)
//             .user
//             ?.empProductionEntity;

//     final pcid = Provider.of<CardNoProvider>(context, listen: false)
//         .user
//         ?.scanCardForItem
//         ?.pcId;
//     final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
//         .user
//         ?.shiftStatusdetailEntity
//         ?.psShiftId;

//     final ppId = Provider.of<TargetQtyProvider>(context, listen: false)
//         .user
//         ?.targetQty
//         ?.ppid;

//     // DateTime parsedLastUpdatedTime =
//     //     DateFormat('yyyy-MM-dd HH:mm').parse(lastUpdatedTime!);
//     final empproduction = responsedata;
//     print(empproduction);
//     if (empproduction != null) {
//       // Check if empproduction is not empty
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String token = pref.getString("client_token") ?? "";

//       now = DateTime.now();
//       currentYear = now.year;
//       currentMonth = now.month;
//       currentDay = now.day;
//       currentHour = now.hour;
//       currentMinute = now.minute;
//       currentSecond = now.second;
//       final currentDateTime =
//           '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString()}:${currentSecond.toString()}';
//       //String toDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//       ProductionEntryReqModel requestBody = ProductionEntryReqModel(
//         apiFor: "update_production",
//         clientAuthToken: token,
//         // emppersonid: empid,
//         // goodQuantities: empproduction.first.goodqty,
//         // rejectedQuantities: empproduction.first.rejqty,
//         // reworkQuantities: empproduction.first.ipdflagid,
//         ipdRejQty: int.tryParse(rejectedQController.text) ?? 0,
//         ipdReworkFlag: reworkValue ?? empproduction.ipdflagid,
//         ipdGoodQty: int.tryParse(goodQController.text) ?? 0,
//         batchno: int.tryParse(batchNOController.text),
//         targetqty: int.tryParse(targetQtyController.text),

//         ipdCardNo: int.tryParse(cardNoController.text.toString()),

//         ipdpaid: activityid ?? 0,
//         ipdFromTime: empproduction.ipdfromtime == ""
//             ? currentDateTime.toString()
//             : empproduction.ipdfromtime,

//         ipdToTime: lastUpdatedTime ?? currentDateTime,
//         ipdDate: currentDateTime.toString(),
//         ipdId: 0,
//         // activityid == empproduction.ipdpaid ? empproduction.ipdid : 0,
//         ipdPcId: pcid ?? empproduction.ipdpcid,
//         ipdDeptId: widget.deptid ?? 1,
//         ipdAssetId: int.tryParse(assetCotroller.text.toString()),
//         //ipdcardno: empproduction.first.ipdcardno,
//         ipdItemId: product_Id,
//         ipdMpmId: processid,
//         emppersonId: widget.empid ?? 0,
//         ipdpsid: widget.psid,
//         ppid: ppId ?? 0,
//         shiftid: Shiftid,
//       );

//       final requestBodyjson = jsonEncode(requestBody.toJson());

//       print(requestBodyjson);

//       const timeoutDuration = Duration(seconds: 30);
//       try {
//         http.Response response = await http
//             .post(
//               Uri.parse(ApiConstant.baseUrl),
//               headers: {
//                 'Content-Type': 'application/json',
//               },
//               body: requestBodyjson,
//             )
//             .timeout(timeoutDuration);

//         // ignore: avoid_print
//         print(response.body);

//         if (response.statusCode == 200) {
//           try {
//             final responseJson = jsonDecode(response.body);
//             print(responseJson);
//             return responseJson;
//           } catch (e) {
//             // Handle the case where the response body is not a valid JSON object
//             throw ("Invalid JSON response from the server");
//           }
//         } else {
//           throw ("Server responded with status code ${response.statusCode}");
//         }
//       } on TimeoutException {
//         throw ('Connection timed out. Please check your internet connection.');
//       } catch (e) {
//         ShowError.showAlert(context, e.toString());
//       }
//       // Handle response if needed
//     } else {
//       // Handle case when empproduction is empty
//       print("empproduction is empty");
//     }
//   }

// void _closeShiftPop(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             backgroundColor: Colors.white,
//             child: WillPopScope(
//               onWillPop: () async {
//                 return false;
//               },
//               child: Container(
//                 width: 200,
//                 height: 150,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 32,
//                   ),
//                   child: Column(children: [
//                     const Text("Confirm you submission"),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               try {
//                                  await EmpClosesShift.empCloseShift(
//                                     'emp_close_shift',
//                                     widget.psid ?? 0,
//                                     2,
//                                     widget.attenceid ?? " ",
//                                     widget.attendceStatus ?? 0);
//                                 await employeeApiService.employeeList(
//                                     context: context,
//                                     deptid: widget.deptid ?? 1,
//                                     processid: widget.processid ?? 0,
//                                     psid:  widget.psid ?? 0);
//                                 Navigator.pop(context);
//                               } catch (error) {
//                                 // Handle and show the error message here
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(error.toString()),
//                                     backgroundColor: Colors.amber,
//                                   ),
//                                 );
//                               }
//                             },
//                             child: const Text("Submit"),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Go back")),
//                         ],
//                       ),
//                     )
//                   ]),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   delete({
//     int? ipdid,
//     int? ipdpsid,
//   }) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String token = pref.getString("client_token") ?? "";
//     final requestBody = DeleteProductionEntryModel(
//         apiFor: "delete_entry",
//         clientAuthToken: token,
//         ipdid: ipdid,
//         ipdpsid: ipdpsid);
//     final requestBodyjson = jsonEncode(requestBody.toJson());

//     print(requestBodyjson);

//     const timeoutDuration = Duration(seconds: 30);
//     try {
//       http.Response response = await http
//           .post(
//             Uri.parse(ApiConstant.baseUrl),
//             headers: {
//               'Content-Type': 'application/json',
//             },
//             body: requestBodyjson,
//           )
//           .timeout(timeoutDuration);

//       // ignore: avoid_print
//       print(response.body);

//       if (response.statusCode == 200) {
//         try {
//           final responseJson = jsonDecode(response.body);
//           // loadEmployeeList();
//           print(responseJson);
//           return responseJson;
//         } catch (e) {
//           // Handle the case where the response body is not a valid JSON object
//           throw ("Invalid JSON response from the server");
//         }
//       } else {
//         throw ("Server responded with status code ${response.statusCode}");
//       }
//     } on TimeoutException {
//       throw ('Connection timed out. Please check your internet connection.');
//     } catch (e) {
//       ShowError.showAlert(context, e.toString());
//     }
//   }

//   void updateinitial() {
//     if (widget.isload == true) {
//       final productionEntry =
//           Provider.of<EmpProductionEntryProvider>(context, listen: false)
//               .user
//               ?.empProductionEntity;
//       final productname = Provider.of<ProductProvider>(context, listen: false)
//           .user
//           ?.listofProductEntity;

//       setState(() {
//         assetCotroller.text = productionEntry?.ipdassetid?.toString() ?? "0";
//         cardNoController.text = productionEntry?.ipdcardno?.toString() ?? "0";

//         // If itemid is not 0, find the matching product name
//         productNameController.text = (productionEntry?.itemid != 0
//             ? productname
//                 ?.firstWhere(
//                   (product) => productionEntry?.itemid == product.productid,
//                 )
//                 .productName
//             : "0")!;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     _fetchARecentActivity().then((_) {
//       updateinitial();
//     });

//     currentDateTime = DateTime.now();
//     now = DateTime.now();
//     currentYear = now.year;
//     currentMonth = now.month;
//     currentDay = now.day;
//     currentHour = now.hour;
//     currentMinute = now.minute;
//     currentSecond = now.second;
//     final shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
//         .user
//         ?.shiftStatusdetailEntity
//         ?.psShiftId;
//     String? shiftTime;

//     final shiftToTimeString =
//         Provider.of<ShiftStatusProvider>(context, listen: false)
//             .user
//             ?.shiftStatusdetailEntity
//             ?.shiftToTime;

//     if (shiftToTimeString != null) {
//       DateTime? shiftToTime;
//       // Parse the shiftToTime
//       final shiftToTimeParts = shiftToTimeString.split(':');
//       final now = DateTime.now();
//       shiftToTime = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         int.parse(shiftToTimeParts[0]),
//         int.parse(shiftToTimeParts[1]),
//         int.parse(shiftToTimeParts[2]),
//       );

//       // Get the current time
//       final currentTime = DateTime.now();

//       final shiftFromTimeString =
//           Provider.of<ShiftStatusProvider>(context, listen: false)
//               .user
//               ?.shiftStatusdetailEntity
//               ?.shiftFromTime;

//       if (shiftFromTimeString != null) {
//         // Parse the shiftFromTime
//         final shiftFromTimeParts = shiftFromTimeString.split(':');
//         final shiftFromTime = DateTime(
//           now.year,
//           now.month,
//           now.day,
//           int.parse(shiftFromTimeParts[0]),
//           int.parse(shiftFromTimeParts[1]),
//           int.parse(shiftFromTimeParts[2]),
//         );
// // Check if shiftToTime is on the next day
//         if (shiftToTime.isBefore(shiftFromTime)) {
//           shiftToTime = shiftToTime.add(Duration(days: 1));
//         }

//         if (currentTime.isAfter(shiftFromTime) &&
//             currentTime.isBefore(shiftToTime)) {
//           // Current time is within the shift time
//           final timeString =
//               '$currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}';
//           shiftTime = timeString;
//         } else {
//           // Current time exceeds the shift time
//           print("Current time exceeds the shift time.");
//           shiftTime = shiftToTimeString;
//         }
//       } else {
//         print("shiftToTime is not available.");
//         // Handle the case where shiftToTime is not available
//       }
//     }
// // Assuming currentYear, currentMonth, and currentDay are defined earlier in your code

//     lastUpdatedTime = '$currentYear-$currentMonth-$currentDay $shiftTime';
//     currentDate =
//         '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}';
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // Dispose text controllers
//     targetQtyController.dispose();
//     goodQController.dispose();
//     rejectedQController.dispose();
//   }

//   String _formatDateTime(DateTime dateTime) {
//     return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
//   }

//   Future<void> _fetchARecentActivity() async {
//     try {
//       // Fetch data
//       await empProductionEntryService.productionentry(
//           context: context,
//           id: widget.empid ?? 0,
//           deptid: widget.deptid ?? 0,
//           psid: widget.psid ?? 0);

//       await productApiService.productList(
//           context: context,
//           id: widget.processid ?? 1,
//           deptId: widget.deptid ?? 0);

//       await recentActivityService.getRecentActivity(
//           context: context,
//           id: widget.empid ?? 0,
//           deptid: widget.deptid ?? 0,
//           psid: widget.psid ?? 0);

//       await activityService.getActivity(
//           context: context,
//           id: widget.processid ?? 0,
//           deptid: widget.deptid ?? 0);

//       final productionEntry =
//           Provider.of<EmpProductionEntryProvider>(context, listen: false)
//               .user
//               ?.empProductionEntity;

//       // Access fetched data and set initial values
//       final initialValue = productionEntry?.ipdflagid;

//       if (initialValue != null) {
//         setState(() {
//           isChecked = initialValue == 1;
//           goodQController.text = productionEntry?.goodqty?.toString() ?? "";
//           rejectedQController.text = productionEntry?.rejqty?.toString() ?? "";
//           batchNOController.text = productionEntry?.ipdbatchno.toString() ??
//               ""; // Set isChecked based on initialValue
//         });
//       }
//       // Update cardNo with the retrieved cardNumber
//       // setState(() {
//       //   cardNo = productionEntry?.ipdcardno?.toString() ??"0"; // Set cardNo with the retrieved value
//       // });

//       setState(() {
//         // Set initial values inside setState
//         isLoading = false; // Set isLoading to false when data is fetched
//       });
//     } catch (e) {
//       // Handle errors
//       setState(() {
//         isLoading = false; // Set isLoading to false even if there's an error
//       });
//     }
//   }


//   void _submitPop(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             backgroundColor: Colors.white,
//             child: WillPopScope(
//               onWillPop: () async {
//                 return false;
//               },
//               child: Container(
//                 width: 200,
//                 height: 150,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 32,
//                   ),
//                   child: Column(children: [
//                     const Text("Confirm you submission"),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               try {
//                                 if (dropdownProduct != null &&
//                                         dropdownProduct != 'Select' &&
//                                         goodQController.text.isNotEmpty ||
//                                     rejectedQController.text.isNotEmpty ||
//                                     reworkQController.text.isNotEmpty) {
//                                   await updateproduction(widget.processid);
//                                   await _fetchARecentActivity();
//                                   Navigator.pop(context);
//                                 }
//                               } catch (error) {
//                                 // Handle and show the error message here
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(error.toString()),
//                                     backgroundColor: Colors.amber,
//                                   ),
//                                 );
//                               }
//                             },
//                             child: const Text("Submit"),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Go back")),
//                         ],
//                       ),
//                     )
//                   ]),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   void deletePop(BuildContext context, ipdid, ipdpsid) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             backgroundColor: Colors.white,
//             child: WillPopScope(
//               onWillPop: () async {
//                 return false;
//               },
//               child: Container(
//                 width: 200,
//                 height: 150,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 32,
//                   ),
//                   child: Column(children: [
//                     const Text("Confirm you submission"),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               try {
//                                 await delete(
//                                     ipdid: ipdid ?? 0, ipdpsid: ipdpsid ?? 0);
//                                 await _fetchARecentActivity();
//                                 Navigator.pop(context);
//                               } catch (error) {
//                                 // Handle and show the error message here
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(error.toString()),
//                                     backgroundColor: Colors.amber,
//                                   ),
//                                 );
//                               }
//                             },
//                             child: const Text("Submit"),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Go back")),
//                         ],
//                       ),
//                     )
//                   ]),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final productionEntry =
//         Provider.of<EmpProductionEntryProvider>(context, listen: false)
//             .user
//             ?.empProductionEntity;

//     final totalGoodQty = productionEntry?.totalGoodqty;
//     final totalRejQty = productionEntry?.totalRejqty;
//  final productname = Provider.of<ProductProvider>(context, listen: false)
//           .user
//           ?.listofProductEntity;
    

//     final recentActivity =
//         Provider.of<RecentActivityProvider>(context, listen: false)
//             .user
//             ?.recentActivitesEntityList;
//     print(productionEntry);
//     final fromtime = productionEntry?.ipdfromtime == ""
//         ? currentDate
//         : productionEntry?.ipdfromtime;

//     // final productname = Provider.of<ProductProvider>(context, listen: false)
//     //     .user
//     //     ?.listofProductEntity;

//     final activity = Provider.of<ActivityProvider>(context, listen: false)
//         .user
//         ?.activityEntity;

//     // final activityName = activity?.map((process) => process.paActivityName)?.toSet()?.toList() ??
//     //         [];

//     // final ProductNames =
//     //     productname?.map((process) => process.productName)?.toSet()?.toList() ??
//     //         [];
//     // final asset = Provider.of<AssetBarcodeProvider>(context, listen: false)
//     //     .user
//     //     ?.scanAseetBarcode;

//     final shiftFromtime =
//         Provider.of<ShiftStatusProvider>(context, listen: false)
//             .user
//             ?.shiftStatusdetailEntity
//             ?.shiftFromTime;
//     final shiftTotime = Provider.of<ShiftStatusProvider>(context, listen: false)
//         .user
//         ?.shiftStatusdetailEntity
//         ?.shiftToTime;

//     // final cardNumber = Provider.of<CardNoProvider>(context, listen: false)
//     //     .user
//     //     ?.scanCardForItem;

//     final processName = Provider.of<EmployeeProvider>(context, listen: false)
//             .user
//             ?.listofEmployeeEntity
//             ?.first
//             .processName ??
//         "";
//     // Set cardNo with the retrieved value

//     // Update cardNo with the retrieved cardNumber

//     // Assuming 1 means true // Assuming ipdid is an int

// // final matchingProduct = productname?.firstWhere(
// //   (product) => product.productid == (productionEntry?.ipdid ?? 0),

// // );
// // if (matchingProduct != null) {
// //   dropdownProduct = matchingProduct.productName;
// // }

//     return isLoading
//         ? Scaffold(
//             body: Center(
//               child: LottieLoadingAnimation(),
//             ),
//           )
//         : Scaffold(
//             backgroundColor: Colors.grey.shade300,
//             appBar: AppBar(
//               leading: IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () {
//                     employeeApiService.employeeList(
//                         context: context,
//                         processid: widget.processid ?? 0,
//                         deptid: widget.deptid ?? 1,
//                         psid: widget.psid ?? 0);
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => ResponsiveTabletHomepage(),
//                     ));
//                   }),
//               title: Text(
//                 '${processName}',
//                 style: TextStyle(color: Colors.white),
//               ),
//               backgroundColor: Color.fromARGB(255, 45, 54, 104),
//               automaticallyImplyLeading: true,
//             ),
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Form(
//                       key: _formkey,
//                       child: Container(
//                        height: size.height*0.90,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey.shade200,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Column(
//                             children: [
//                               Container(
//                                 height:    size.height*0.095,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5))),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 15, right: 15 ,top: 5),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 2,
//                                         child: Row(
//                                           children: [
//                                           Text('Timing :',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color: Colors.black54))
//                                                     ,
//                                                     SizedBox(width: 20,),
//                                             Text('${fromtime}',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color: Colors.black54))
//                                                     ,
//                                                     SizedBox(width: 20,),
//                                                       Text('to',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color: Colors.black54)),

//                                                     SizedBox(width: 20,),
//                                                       Text(' ${lastUpdatedTime}',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color: Colors.black54)),
//                                                     SizedBox(width: 30,),
//                                                      UpdateTime(
//                                               onTimeChanged: (time) {
//                                                 setState(() {
//                                                   lastUpdatedTime = time
//                                                       .toString(); // Update the manually set time
//                                                 });
//                                               },
//                                               shiftFromTime:
//                                                   shiftFromtime ?? "",
//                                               shiftToTime: shiftTotime ?? "",
//                                             ),
//                                           ],
//                                         ),
//                                       ),

//                                         SizedBox(
//                                         height: 40,
//                                         child: CustomButton(
//                                                     width: 150,
//                                                     height: 50,
//                                                     onPressed: () {

//                                        _closeShiftPop(context);
//                                         },
//                                         child: Text('Close Shift',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: Colors.white)),
//                                                     backgroundColor: Colors.green,
//                                                     borderRadius: BorderRadius.circular(50),
//                                                   ),
//                                       ),
                                    
//                                       SizedBox(width: 10,),

//                                       SizedBox(
//                                         height: 40,
//                                         child: CustomButton(
//                                                     width: 150,
//                                                     height: 50,
//                                                     onPressed:selectedName != null
//                                         ? () {
//                                               if (_formkey.currentState
//                                                       ?.validate() ??
//                                                   false) {
//                                                 // If the form is valid, perform your actions
//                                                 print('Form is valid');
//                                                 _submitPop(
//                                                     context); // Call _submitPop function or perform actions here
//                                               } else {
//                                                 // If the form is not valid, you can handle this case as needed
//                                                 print('Form is not valid');
//                                                 // Optionally, show an error message or handle the invalid case
//                                               } 
//                                           }
//                                         : null,
                                                      
                                             
//                                                     child: Text(
//                                               'Submit',
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.white),
//                                             ),
//                                                     backgroundColor: Colors.green,
//                                                     borderRadius: BorderRadius.circular(50),
//                                                   ),
//                                       ),
                                      
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       width: size.width*0.30,
//                                       height: size.height*0.30,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Text('Batch No',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black87)),
//                                                   SizedBox(
//                                                     width: 60,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 150,
//                                                     height: 40,
//                                                     child: CustomNumField(
//                                                       controller:
//                                                           batchNOController,
//                                                       hintText: 'Batch No  ',
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 40,
//                                                   ),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         Text('Activity ',
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),
//                                                         SizedBox(width: 55),
//                                                         Container(
//                                                             width: 150,
//                                                             height: 40,
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               border: Border.all(
//                                                                   width: 1,
//                                                                   color: Colors
//                                                                       .grey),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .all(Radius
//                                                                           .circular(
//                                                                               5)),
//                                                             ),
//                                                             child:
//                                                                 DropdownButtonFormField<
//                                                                     String>(
//                                                               value:
//                                                                   activityDropdown,
//                                                               decoration:
//                                                                   InputDecoration(
//                                                                 contentPadding:
//                                                                     EdgeInsets.symmetric(
//                                                                         horizontal:
//                                                                             10),
//                                                                 border:
//                                                                     InputBorder
//                                                                         .none,
//                                                               ),
//                                                               hint: Text(
//                                                                   "Select"),
//                                                               isExpanded: true,
//                                                               onChanged: (String?
//                                                                   newvalue) async {
//                                                                 if (newvalue !=
//                                                                     null) {
//                                                                   setState(() {
//                                                                     activityDropdown =
//                                                                         newvalue;
//                                                                   });

//                                                                   final selectedActivity =
//                                                                       activity
//                                                                           ?.firstWhere(
//                                                                     (activity) =>
//                                                                         activity
//                                                                             .paActivityName ==
//                                                                         newvalue,
//                                                                     orElse: () => ActivityProduct(
//                                                                         paActivityName:
//                                                                             '',
//                                                                         paId: 0,
//                                                                         paMpmId:
//                                                                             0),
//                                                                   );

//                                                                   if (selectedActivity !=
//                                                                           null &&
//                                                                       selectedActivity
//                                                                               .paId !=
//                                                                           null) {
//                                                                     activityid =
//                                                                         selectedActivity.paId ??
//                                                                             0;

//                                                                     await targetQtyApiService
//                                                                         .getTargetQty(
//                                                                       context:
//                                                                           context,
//                                                                       paId:
//                                                                           activityid ??
//                                                                               0,
//                                                                       deptid:
//                                                                           widget.deptid ??
//                                                                               1,
//                                                                       psid:
//                                                                           widget.psid ??
//                                                                               0,
//                                                                       empid:
//                                                                           widget.empid ??
//                                                                               0,
//                                                                     );

//                                                                     final targetqty = Provider.of<TargetQtyProvider>(
//                                                                             context,
//                                                                             listen:
//                                                                                 false)
//                                                                         .user
//                                                                         ?.targetQty;

//                                                                     setState(
//                                                                         () {
//                                                                       targetQtyController
//                                                                           .text = targetqty
//                                                                               ?.targetqty
//                                                                               ?.toString() ??
//                                                                           '';
//                                                                       achivedTargetQty =
//                                                                           targetqty?.achivedtargetqty?.toString() ??
//                                                                               "";
//                                                                     });
//                                                                   }
//                                                                 } else {
//                                                                   setState(() {
//                                                                     activityDropdown =
//                                                                         null;
//                                                                     activityid =
//                                                                         0;
//                                                                   });
//                                                                 }
//                                                               },
//                                                               items: activity
//                                                                       ?.map(
//                                                                         (activityName) {
//                                                                           return DropdownMenuItem<
//                                                                               String>(
//                                                                             onTap:
//                                                                                 () {
//                                                                               setState(() {
//                                                                                 selectedName = activityName.paActivityName;
//                                                                               });
//                                                                             },
//                                                                             value:
//                                                                                 '${activityName.paActivityName}', // Append index to ensure uniqueness
//                                                                             child:
//                                                                                 Text(
//                                                                               activityName.paActivityName ?? "",
//                                                                               style: TextStyle(color: Colors.black87),
//                                                                             ),
//                                                                           );
//                                                                         },
//                                                                       )
//                                                                       ?.toSet()
//                                                                       .toList() ??
//                                                                   [],
//                                                             )),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Text('Card NO ',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black87)),
//                                                   CardNoScanner(
//                                                     empId: widget.empid,
//                                                     processId: widget.processid,
//                                                     onCardDataReceived:
//                                                         (scannedCardNo,
//                                                             scannedProductName) {
//                                                       setState(() {
//                                                         cardNoController.text =
//                                                             scannedCardNo;
//                                                         productNameController
//                                                                 .text =
//                                                             scannedProductName;
//                                                       });
//                                                     },
//                                                   ),
//                                                   SizedBox(width: 20),

//                                                   SizedBox(
//                                                     width: 150,
//                                                     height: 40,
//                                                     child: CustomNumField(
//                                                       controller:
//                                                           cardNoController,
//                                                       hintText: 'Card NO ',
//                                                       // Only digits allowed
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 40,
//                                                   ),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         SizedBox(
//                                                           height: 8,
//                                                         ),
//                                                         Text("Item Ref ",
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),
//                                                         SizedBox(width: 50),
//                                                         SizedBox(
//                                                             width: 150,
//                                                             height: 40,
//                                                             child: Consumer<
//                                                                 ProductProvider>(
//                                                               builder: (context,
//                                                                   productProvider,
//                                                                   child) {
//                                                                 final productList =
//                                                                     productProvider
//                                                                             .user
//                                                                             ?.listofProductEntity ??
//                                                                         [];

//                                                                 return CustomNumField(
//                                                                   controller:
//                                                                       productNameController,
//                                                                   hintText:
//                                                                       'Item Ref',
//                                                                   keyboardtype:
//                                                                       TextInputType
//                                                                           .streetAddress,
//                                                                   isAlphanumeric:
//                                                                       true,
//                                                                   validation:
//                                                                       (value) {
//                                                                     if (value ==
//                                                                             null ||
//                                                                         value
//                                                                             .isEmpty) {
//                                                                       return 'Please enter a product name';
//                                                                     }

//                                                                     // Convert product names in productList to lowercase for case-insensitive comparison
//                                                                     final productListLowercase = productList
//                                                                         .map((product) => product
//                                                                             .productName
//                                                                             ?.toLowerCase())
//                                                                         .toList();

//                                                                     // Check if any product name matches the entered value (case-insensitive)
//                                                                     final index =
//                                                                         productListLowercase.indexWhere((productName) =>
//                                                                             productName ==
//                                                                             value.toLowerCase());

//                                                                     if (index !=
//                                                                         -1) {
//                                                                       // Product found, update the controller with product id
//                                                                       final product =
//                                                                           productList[
//                                                                               index];
//                                                                       product_Id =
//                                                                           product
//                                                                               .productid;
//                                                                       return null; // Valid input
//                                                                     } else {
//                                                                       // Product not found
//                                                                       return 'Product name not found';
//                                                                     }
//                                                                   },
//                                                                 );
//                                                               },
//                                                             )),
//                                                       ],
//                                                     ),
//                                                   ),

//                                                   // Text('  ${cardNo}' ?? "0"),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 20,
//                                             ),
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Text('Asset Id',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black87)),
//                                                   SizedBox(width: 8),
//                                                   ScanBarcode(
//                                                     empId: widget.empid,
//                                                     processId: widget.processid,
//                                                     onCardDataReceived:
//                                                         (scannedAssetId) {
//                                                       setState(() {
//                                                         assetCotroller.text =
//                                                             scannedAssetId;
//                                                       });
//                                                     },
//                                                   ),
//                                                   SizedBox(width: 16),
//                                                   SizedBox(
//                                                     width: 150,
//                                                     height: 40,
//                                                     child: CustomNumField(
//                                                       controller:
//                                                           assetCotroller,
//                                                       hintText: 'Asset id',
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 40,
//                                                   ),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         Text('Target Qty',
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),
//                                                         SizedBox(
//                                                           width: 40,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 150,
//                                                           height: 40,
//                                                           child: CustomNumField(
//                                                             controller:
//                                                                 targetQtyController,
//                                                             hintText:
//                                                                 'Target Quantity',
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                width: size.width*0.30,
//                                       height: size.height*0.30,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Text('Good Qty',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black87)),
//                                                   SizedBox(
//                                                     width: 50,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 150,
//                                                     height: 40,
//                                                     child: CustomNumField(
//                                                       controller:
//                                                           goodQController,
//                                                       hintText: 'Good Quantity',
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 40,
//                                                   ),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         Text(
//                                                             'Completed Good Qty',
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),
//                                                         SizedBox(
//                                                           width: 60,
//                                                         ),
//                                                         Text("${totalGoodQty}",
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Text('Rejected Qty',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black87)),
//                                                   SizedBox(
//                                                     width: 25,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 150,
//                                                     height: 40,
//                                                     child: CustomNumField(
//                                                       controller:
//                                                           rejectedQController,
//                                                       hintText:
//                                                           'Rejected Quantity',
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 35,
//                                                   ),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         Text(
//                                                             'Completed Rejected Qty',
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),

//                                                         SizedBox(width: 35),

//                                                         Text("${totalRejQty}",
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),

//                                                         // Text('  ${cardNo}' ?? "0"),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Text('Rework',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black87)),
//                                                   SizedBox(
//                                                     width: 2,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 150,
//                                                     height: 40,
//                                                     child: Checkbox(
//                                                       value: isChecked,
//                                                       activeColor: Colors.green,
//                                                       onChanged: (newValue) {
//                                                         setState(() {
//                                                           isChecked =
//                                                               newValue ?? false;
//                                                           reworkValue =
//                                                               isChecked ? 1 : 0;
//                                                         });
//                                                         print(
//                                                             "reworkvalue  ${reworkValue}");
//                                                         // Perform any additional actions here, such as updating the database
//                                                       },
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 100,
//                                                   ),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         SizedBox(
//                                                           height: 8,
//                                                         ),
//                                                         Text(
//                                                             "Remaining Target Qty",
//                                                             style: TextStyle(
//                                                                 fontSize: 17,
//                                                                 color: Colors
//                                                                     .black87)),
//                                                         SizedBox(width: 60),
//                                                         Text(
//                                                           "${achivedTargetQty == null ? "0" : achivedTargetQty}",
//                                                           style: TextStyle(
//                                                               fontSize: 17,
//                                                               color: Colors
//                                                                   .black87),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
                            
                             
//                               // Row(
//                               //   mainAxisAlignment: MainAxisAlignment.start,
//                               //   children: [
//                               //     Text(
//                               //       'Recent Activities',
//                               //       style: TextStyle(
//                               //         fontSize: 20,
//                               //       ),
//                               //     ),
//                               //   ],
//                               // ),
//                               SizedBox(height: 10),
//                               (recentActivity != null &&
//                                       recentActivity.isNotEmpty)
//                                   ? Column(
//                                       children: [
//                                         Container(
//                                           height: 55,
//                                           width: double.infinity,
//                                           decoration: const BoxDecoration(
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(8),
//                                                   topRight: Radius.circular(8)),
//                                               color: Color.fromARGB(
//                                                   255, 45, 54, 104)),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 alignment: Alignment.centerLeft,
//                                                 width: 100,
//                                                 child: Text('S.NO',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: 150,
//                                                 child: Text('Prev Time',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: 150,
//                                                 child: Text('Product Name',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: 150,
//                                                 child: Text('Good Qty',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: 150,
//                                                 child: Text('Rejected Qty',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: 150,
//                                                 child: Text('Rework ',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: 150,
//                                                 child: Text('Edit Entries',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: 150,
//                                                 child: Text('Delete Entry',
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           decoration: const BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.only(
//                                                   bottomLeft:
//                                                       Radius.circular(8),
//                                                   bottomRight:
//                                                       Radius.circular(8))),
//                                           width: double.infinity,
                                       
//                                       height: size.height*0.37,
//                                           child: ListView.builder(
//                                             shrinkWrap: true,
//                                             itemCount: recentActivity?.length,
//                                             itemBuilder: (context, index) {
//                                               final data =
//                                                   recentActivity?[index];
//                                               return Container(
//                                                 decoration: BoxDecoration(
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                         width: 1,
//                                                         color: Colors
//                                                             .grey.shade300),
//                                                   ),
//                                                   color: index % 2 == 0
//                                                       ? Colors.grey.shade50
//                                                       : Colors.grey.shade100,
//                                                 ),
//                                                 height: 80,
//                                                 width: double.infinity,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       width: 100,
//                                                       child: Text(
//                                                         ' ${index + 1}  ',
//                                                         style: TextStyle(
//                                                             color: Colors
//                                                                 .grey.shade900),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                        alignment:
//                                                           Alignment.centerRight,
//                                                       width: 150,
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(left: 35),
//                                                         child: Text(
//                                                           ' ${data?.ipdtotime ?? ''}  ',
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .grey.shade900),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.center,
//                                                       width: 150,
//                                                       child: Text(
                                                       
//                                                         '${
//                                                        (data?.ipditemid != 0
//             ? productname
//                 ?.firstWhere(
//                   (product) =>data?.ipditemid == product.productid,
//                 )
//                 .productName
//             : " ")}',
//                                                         style: TextStyle(
//                                                             color: Colors
//                                                                 .grey.shade900),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.center,
//                                                       width: 150,
//                                                       child: Text(
//                                                         '  ${data?.ipdgoodqty ?? ''} ',
//                                                         style: TextStyle(
//                                                             color: Colors
//                                                                 .grey.shade900),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.center,
//                                                       width: 150,
//                                                       child: Text(
//                                                         '  ${data?.ipdrejqty ?? ''}',
//                                                         style: TextStyle(
//                                                             color: Colors
//                                                                 .grey.shade900),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.center,
//                                                       width: 150,
//                                                       child: Text(
//                                                         '  ${data?.ipdreworkflag == 0 ? 'NO' : "Yes"} ',
//                                                         style: TextStyle(
//                                                             color: Colors
//                                                                 .grey.shade900),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.center,
//                                                       width: 150,
//                                                       child: IconButton(
//                                                         onPressed: () {
//                                                           Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                 builder:
//                                                                     (context) =>
//                                                                         EditEmpProductionEntryPage(
//                                                                   deptid:
//                                                                       data?.deptid ??
//                                                                           1057,
//                                                                   empid:
//                                                                       data?.ipdempid ??
//                                                                           0,
//                                                                   isload: true,
//                                                                   processid:
//                                                                       data?.processid ??
//                                                                           0,
//                                                                   psid: data
//                                                                       ?.ipdpsid,
//                                                                   ipdid: data
//                                                                       ?.ipdid,
//                                                                   attenceid: widget
//                                                                       .attenceid,
//                                                                   attendceStatus:
//                                                                       widget
//                                                                           .attendceStatus,
//                                                                 ),
//                                                               ));
//                                                         },
//                                                         icon: const Icon(
//                                                             Icons
//                                                                 .mode_edit_outline_outlined,
//                                                             size: 25,
//                                                             color: Colors.blue),
//                                                       ),
//                                                     ),
//                                                     if (index == 0)
//                                                       Container(
//                                                         alignment:
//                                                             Alignment.center,
//                                                         width: 150,
//                                                         child: IconButton(
//                                                           onPressed: () async {
//                                                             // updateproduction(widget.processid);
//                                                             deletePop(
//                                                                 context,
//                                                                 data?.ipdid ??
//                                                                     0,
//                                                                 data?.ipdpsid ??
//                                                                     0);
//                                                           },
//                                                           icon: const Icon(
//                                                               Icons.delete,
//                                                               size: 25,
//                                                               color:
//                                                                   Colors.red),
//                                                         ),
//                                                       ),
//                                                     if (index != 0)
//                                                       Container(
//                                                           alignment:
//                                                               Alignment.center,
//                                                           width: 150,
//                                                           child: Text("")),
//                                                   ],
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   : Center(
//                                       child: Text("No data available"),
//                                     ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }
// }
