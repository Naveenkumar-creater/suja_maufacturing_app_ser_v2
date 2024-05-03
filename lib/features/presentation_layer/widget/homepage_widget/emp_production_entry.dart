// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja/constant/lottieLoadingAnimation.dart';
import 'package:suja/constant/productuion_entry_model.dart';
import 'package:suja/features/presentation_layer/api_services/activity_di.dart';
import 'package:suja/features/presentation_layer/api_services/asset_barcode_di.dart';
import 'package:suja/features/presentation_layer/api_services/card_no_di.dart';
import 'package:suja/features/presentation_layer/api_services/emp_production_entry_di.dart';
import 'package:suja/features/presentation_layer/api_services/recent_activity.dart';
import 'package:suja/features/presentation_layer/api_services/target_qty_di.dart';
import 'package:suja/features/presentation_layer/provider/activity_provider.dart';
import 'package:suja/features/presentation_layer/provider/asset_barcode_provier.dart';
import 'package:suja/features/presentation_layer/provider/card_no_provider.dart';
import 'package:suja/features/presentation_layer/provider/emp_production_entry_provider.dart';
import 'package:suja/features/presentation_layer/provider/employee_provider.dart';
import 'package:suja/features/presentation_layer/provider/product_provider.dart';
import 'package:suja/features/presentation_layer/provider/recent_activity_provider.dart';
import 'package:suja/features/presentation_layer/provider/target_qty_provider.dart';
import 'package:suja/features/presentation_layer/widget/emp_production_entry_widget/emp_asset_barcode_scan.dart';
import 'package:suja/features/presentation_layer/widget/emp_production_entry_widget/emp_cardno_barcode_scanner.dart';
import '../../api_services/product_di.dart';
import '../production_quanties/emp_production_time.dart';
import '../../../../constant/request_model.dart';
import '../../../../constant/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../../../constant/utilities/customnum_field.dart';

class EmpProductionEntryPage extends StatefulWidget {
  final int? empid;
  final int? processid;
  final String? barcode;
  final int? cardno;
  final int?assetid;
  final int? shiftId;
bool? isload;

  EmpProductionEntryPage({Key? key, this.empid, this.processid, this.barcode, this.cardno, this.assetid, this.isload,this.shiftId})
      : super(key: key);

  @override
  State<EmpProductionEntryPage> createState() => _EmpProductionEntryPageState();
}

class _EmpProductionEntryPageState extends State<EmpProductionEntryPage> {
  final TextEditingController goodQController = TextEditingController();
  final TextEditingController rejectedQController = TextEditingController();
  final TextEditingController reworkQController = TextEditingController();
  final TextEditingController targetQtyController = TextEditingController();
  final ProductApiService productApiService = ProductApiService();
  final RecentActivityService recentActivityService = RecentActivityService();
  final ActivityService activityService = ActivityService();
  final TargetQtyApiService targetQtyApiService= TargetQtyApiService();

  bool isChecked = false;

  bool isLoading = true;
  late DateTime now;
  late int currentYear;
  late int currentMonth;
  late int currentDay;
  late int currentHour;
  late int currentMinute;
  late String currentTime;
  late int currentSecond; // Initialized to avoid null check

  List<Map<String, dynamic>> submittedDataList = [];

  String? dropdownProduct;
  String? activityDropdown;
  String? lastUpdatedTime;
  int? reworkValue;
  int? productid;
  int? activityid;
  TimeOfDay? updateTimeManually;
  String? cardNo;
  String?productName;
  String?assetID;

  EmpProductionEntryService empProductionEntryService =
      EmpProductionEntryService();






  Future<void> updateproduction(int? processid) async {
    final empid = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .empPersonid;
    final responsedata =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;
                final itemid =
        Provider.of<CardNoProvider>(context, listen: false)
            .user
            ?.scanCardForItem?.pcItemId;
            

    final empproduction = responsedata;
    print(empproduction);
    if (empproduction != null) {
      // Check if empproduction is not empty
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      now = DateTime.now();
      currentYear = now.year;
      currentMonth = now.month;
      currentDay = now.day;
      currentHour = now.hour;
      currentMinute = now.minute;
      currentSecond = now.second;
      final currentDateTime =
          '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString()}:${currentSecond.toString()}';
      //String toDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      ProductionEntryReqModel requestBody = ProductionEntryReqModel(
        apiFor: "update_production",
        clientAuthToken: token,
        // emppersonid: empid,
        // goodQuantities: empproduction.first.goodqty,
        // rejectedQuantities: empproduction.first.rejqty,
        // reworkQuantities: empproduction.first.ipdflagid,
        ipdRejQty: int.tryParse(rejectedQController.text) ?? 0,
        ipdReworkFlag: reworkValue ?? empproduction.ipdflagid,
        ipdGoodQty: int.tryParse(goodQController.text) ?? 0,
        ipdCardNo: int.tryParse(cardNo.toString()) ??empproduction.ipdcardno ,

        ipdpaid: empproduction.ipdpaid ?? 0,
        ipdFromTime: empproduction.ipdfromtime == ""
            ? currentDateTime.toString()
            : empproduction.ipdfromtime,

        /// ipdid: empproduction.first.ipdid,
        ipdToTime: lastUpdatedTime?? currentDateTime.toString(),
        ipdDate: currentDateTime.toString(),
        ipdId: empproduction.ipdid ?? 0,

        // ipdfromtime: now,
        // ipdtotime: now,
        // ipddate: now,
        ipdPcId: empproduction.ipdpcid ?? 0,
        ipdDeptId: empproduction.ipddeptid ?? 1,
        ipdAssetId: empproduction.ipdassetid ?? 0,

        //ipdcardno: empproduction.first.ipdcardno,
        ipdItemId: itemid ?? empproduction.itemid,
        ipdMpmId: processid,
        emppersonId: widget.empid ?? 0,
      );

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
      // Handle response if needed
    } else {
      // Handle case when empproduction is empty
      print("empproduction is empty");
    }
  }
void updateinitial() {
  if (widget.isload == true) {
    final productionEntry =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;
    final productname =
        Provider.of<ProductProvider>(context, listen: false)
            .user
            ?.listofProductEntity;

    setState(() {
      assetID = productionEntry?.ipdassetid?.toString() ?? "0";
      cardNo = productionEntry?.ipdcardno?.toString() ?? "0";

      // If itemid is not 0, find the matching product name
      productName = productionEntry?.itemid != 0
          ? productname
              ?.firstWhere(
                (product) => productionEntry?.itemid == product.productid,
               
              )
              ?.productName
          : "0";

    // Assuming you want to set isLoading to false here

      // Set isload to false to prevent this block from executing again

    });
  }

  else if(widget.cardno==1&&widget.isload==false){
    final cardNumber = Provider.of<CardNoProvider>(context, listen: false)
        .user
        ?.scanCardForItem;
 
    setState(() {
      cardNo = cardNumber?.pcCardNo?.toString() ?? "";
      productName=cardNumber?.itemName?.toString() ?? "";
    });

  }
   else if(widget.assetid==1&&widget.isload==false){
    final assetlist = Provider.of<AssetBarcodeProvider>(context, listen: false)
        .user
        ?.scanAseetBarcode;
          final cardNumber = Provider.of<CardNoProvider>(context, listen: false)
        .user
        ?.scanCardForItem;
 
    setState(() {
      cardNo = cardNumber?.pcCardNo?.toString() ?? "";
      productName=cardNumber?.itemName?.toString() ?? "";
    });
    setState(() {
      assetID = assetlist?.pamAssetId?.toString() ?? "";});
  }
}


void updateCardNo(cardStatus) {
  if (cardStatus == 1) {
    final cardNumber = Provider.of<CardNoProvider>(context, listen: false)
        .user
        ?.scanCardForItem;
    setState(() {
      cardNo = cardNumber?.pcCardNo?.toString() ?? "";
      productName=cardNumber?.itemName?.toString() ?? "";
    });
  } else {
    final productionEntry =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;
             final productname =
        Provider.of<ProductProvider>(context, listen: false)
            .user
            ?.listofProductEntity;

    setState(() {
      cardNo =  productionEntry?.ipdcardno?.toString() ?? "0";
      // productName= productname==null? productname?.firstWhere((product) =>product.productid==productionEntry?.itemid ).productName : "";
    productName =productionEntry?.itemid!=0? productname
    ?.firstWhere(
      (product) => productionEntry?.itemid == product.productid,
    // Return null if the item is not found
    )
    ?.productName : "0";



    });
  }
}

void updateAssetNo(assetNo) {
  if (assetNo == 1) {
    final asset = Provider.of<AssetBarcodeProvider>(context, listen: false)
        .user
        ?.scanAseetBarcode;
    setState(() {
      assetID = asset?.pamAssetId?.toString() ?? "";
     
    });
  } else {
    final productionEntry =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;
           
    setState(() {
      assetID =  productionEntry?.ipdassetid?.toString() ?? "0";
      
    });
  }
}



  @override
  void initState() {
    super.initState();
    
    // final int? cardStatus= widget.cardno ??0;
    // final int? assetStatus= widget.assetid ??0;

    // Start fetching data and set initial values
    
     
  _fetchARecentActivity().then((_) {
 

updateinitial();
});


  
   
    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond = now.second;
    lastUpdatedTime =
        '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString()}:${currentSecond.toString()}'; // Initial time display
    print('$currentYear-----------------------');
    
  }

  @override
  void dispose() {
    // Dispose text controllers
    targetQtyController.dispose();
    goodQController.dispose();
    rejectedQController.dispose();

    super.dispose();
  }

 

  Future<void> _fetchARecentActivity() async {
    try {
      // Fetch data
      await empProductionEntryService.productionentry(
          context: context, id: widget.empid ?? 0);
      await productApiService.productList(
          context: context, id: widget.processid ?? 1);
      await recentActivityService.getRecentActivity(
          context: context, id: widget.empid);
      await activityService.getActivity(
          context: context, id: widget.processid ?? 1);
                 final productionEntry =
          Provider.of<EmpProductionEntryProvider>(context, listen: false)
              .user
              ?.empProductionEntity;

          // await targetQtyApiService.getTargetQty(context: context, paId: productionEntry?.ipdpaid??0, shiftId:widget.shiftId??0 );

     
 
          
      // Access fetched data and set initial values
           final initialValue = productionEntry?.ipdflagid;
    
      if (initialValue != null) {
        setState(() {
          isChecked = initialValue == 1; // Set isChecked based on initialValue
        });
      }
      // Update cardNo with the retrieved cardNumber
      // setState(() {
      //   cardNo = productionEntry?.ipdcardno?.toString() ??"0"; // Set cardNo with the retrieved value
      // });

        //  final targetqty =
        //   Provider.of<TargetQtyProvider>(context, listen: false)
        //       .user
        //       ?.targetQty?.targetqty;

      

      goodQController.text = productionEntry?.goodqty?.toString() ?? "";
      rejectedQController.text = productionEntry?.rejqty?.toString() ?? "";
      // targetQtyController.text = targetqty.toString() ?? "";

      setState(() {
        // Set initial values inside setState
        isLoading = false; // Set isLoading to false when data is fetched
      });
    } catch (e) {
      // Handle errors
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
  }



  

  void _submitPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                width: 200,
                height: 150,
                color: Colors.white,
                child: Column(children: [
                  const Text("Confirm you submission"),
                  const SizedBox(
                    height: 16 * 3,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              if (dropdownProduct != null &&
                                      dropdownProduct != 'Select' &&
                                      goodQController.text.isNotEmpty ||
                                  rejectedQController.text.isNotEmpty ||
                                  reworkQController.text.isNotEmpty) {
                                setState(() {
                                  updateproduction(widget.processid);
                                  Navigator.pop(context);
                                });
                              }
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final productionEntry =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;

    final recentActivity =
        Provider.of<RecentActivityProvider>(context, listen: false)
            .user
            ?.recentActivitesEntityList;
    print(productionEntry);
    final fromtime = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity;

    final productname = Provider.of<ProductProvider>(context, listen: false)
        .user
        ?.listofProductEntity;

    final activity = Provider.of<ActivityProvider>(context, listen: false)
        .user
        ?.activityEntity;

    final activityName =
        activity?.map((process) => process.paActivityName)?.toSet()?.toList() ??
            [];

    final ProductNames =
        productname?.map((process) => process.productName)?.toSet()?.toList() ??
            [];
    final asset = Provider.of<AssetBarcodeProvider>(context, listen: false)
        .user
        ?.scanAseetBarcode;

    final cardNumber = Provider.of<CardNoProvider>(context, listen: false)
        .user
        ?.scanCardForItem;




          // Set cardNo with the retrieved value
    
 
   // Update cardNo with the retrieved cardNumber
 
    // Assuming 1 means true // Assuming ipdid is an int

// final matchingProduct = productname?.firstWhere(
//   (product) => product.productid == (productionEntry?.ipdid ?? 0),

// );
// if (matchingProduct != null) {
//   dropdownProduct = matchingProduct.productName;
// }

    return isLoading
        ? Scaffold(
            body: Center(
              child: LottieLoadingAnimation(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back)),
                        Text(
                          'Moulding',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 51, 43, 43)),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 660,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: 300,
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  'From Time :'),
                                                              SizedBox(
                                                                width: 16,
                                                              ),
                                                              Text(
                                                                  '${fromtime?.first.timing}'),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  'End Time :'),
                                                              SizedBox(
                                                                width: 16,
                                                              ),
                                                              Text(
                                                                  '${lastUpdatedTime}'),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: UpdateTime(
                                                            onTimeChanged:
                                                                (time) {
                                                              setState(() {
                                                                lastUpdatedTime =
                                                                    time.toString(); // Update the manually set time
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(child: Text('')),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: 300,
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                    
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text('Card NO '),
                                                              CardNoScanner(
                                                                empId: widget
                                                                    .empid,
                                                                processId: widget
                                                                    .processid,
                                                                     shiftId: widget.shiftId,
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text(':'),
                                                              SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                  '  ${cardNo}' ??
                                                                      "0"),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Text(
                                                                  "Suja Ref              :   ${productName}" ??
                                                                      "0"),
                                                            ],
                                                          ),
                                                        ),  
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  'Activity                :'),
                                                              SizedBox(
                                                                  width: 18),
                                                              // DropdownButton<String?>(
                                                              //     items: ProductNames,
                                                              //     onChanged: onChanged)
                                                              Container(
                                                                width: 150,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .grey),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                ),
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      activityDropdown,
                                                                  hint: Text(
                                                                      "Select"), // Default value is 'Select'
                                                                  underline:
                                                                      Container(
                                                                    height: 5,
                                                                  ),
                                                                  isExpanded:
                                                                      true,
                                                                  onChanged:
                                                                      (String?
                                                                          newvalue) {
                                                                    setState(
                                                                        () {
                                                                      activityDropdown =
                                                                          newvalue;
                                                                      // Set the productid only if newvalue is not null
                                                                      if (newvalue !=
                                                                          null) {
                                                                        activityid = activity!
                                                                            .firstWhere((product) =>
                                                                                product.paActivityName ==
                                                                                newvalue)
                                                                            ?.paId;
                                                                      } else {
                                                                        productid =
                                                                            null;
                                                                      }
                                                                    });
                                                                  },
                                                                  items: activityName
                                                                          ?.map(
                                                                              (activityName) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              activityName,
                                                                          child:
                                                                              Text(
                                                                            activityName ??
                                                                                "",
                                                                            style:
                                                                                TextStyle(color: Colors.black),
                                                                          ),
                                                                        );
                                                                      }).toList() ??
                                                                      [], // Add toList() to avoid null error
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text('Asset Id'),
                                                              SizedBox(
                                                                  width: 8),
                                                              ScanBarcode(
                                                                empId: widget
                                                                    .empid,
                                                                processId: widget
                                                                    .processid,
                                                                    shiftId: widget.shiftId,
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text(':'),
                                                              SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                  '${assetID}' ??
                                                                      "1"),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: 300,
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  'Good Qty        :'),
                                                              SizedBox(
                                                                width: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 180,
                                                                height: 40, 
                                                                child:
                                                                    CustomNumField(
                                                                  controller:
                                                                      goodQController,
                                                                  hintText:
                                                                      'Good Quantity',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                             SizedBox(
                                                                  height: 30),Expanded(
                                                          child: Row(
                                                                                                                  children: [
                                                          Text(
                                                              'Rejected Qty   :'),
                                                          SizedBox(
                                                            width: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            height: 50,
                                                            child:
                                                                CustomNumField(
                                                              controller:
                                                                  rejectedQController,
                                                              hintText:
                                                                  'Rejected Quantity',
                                                            ),
                                                          ),
                                                                                                                  ],
                                                                                                                ),
                                                        ),

                                                         SizedBox(
                                                                  height: 36),
                                                        Expanded(
                                                          child: Row(
                                                                                                                  children: [
                                                          Text(
                                                              'Target Qty       :'),
                                                          SizedBox(
                                                            width: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            height: 40,
                                                            child:
                                                                CustomNumField(
                                                              controller:
                                                                  targetQtyController,
                                                              hintText:
                                                                  'Target Quantity',
                                                            ),
                                                          ),
                                                                                                                  ],
                                                                                                                ),
                                                        ),
                                                         SizedBox(
                                                                  height: 36),
                                                        Expanded(
                                                          child: Row(
                                                                                                                  children: [
                                                          Text('Rework            :'),
                                                          
                                                          SizedBox(
                                                            width: 60,
                                                            height: 40,
                                                            child: Checkbox(
                                                              value: isChecked,
                                                              activeColor:
                                                                  Colors.green,
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  isChecked =
                                                                      newValue ??
                                                                          false;
                                                                  reworkValue =
                                                                      isChecked
                                                                          ? 1
                                                                          : 0;
                                                                });
                                                                print(
                                                                    "reworkvalue  ${reworkValue}");
                                                                // Perform any additional actions here, such as updating the database
                                                              },
                                                            ),
                                                          ),
                                                                                                                  ],
                                                                                                                ),
                                                        ),Expanded(child: Text(''))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                      
                                             
                                            ],
                                          ),
                                        ],
                                      ),SizedBox(
                                                height: 8,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _submitPop(context);
                                                },
                                                child: Text('Submit'),
                                              ),
                                    
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Recent Activities',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      (recentActivity != null &&
                                              recentActivity.isNotEmpty)
                                          ? Column(
                                              children: [
                                                Container(
                                                  height: 80,
                                                  width: double.infinity,
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      8),
                                                              topRight: Radius
                                                                  .circular(
                                                                      8)),
                                                      color: Color.fromARGB(
                                                          255, 45, 54, 104)),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(alignment:Alignment.center,
                                                              width: 100,
                                                        child: Text('S.NO',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Container(alignment:Alignment.center,
                                                              width: 200,
                                                        child: Text('Prev Time',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Container(alignment:Alignment.center,
                                                              width: 200,
                                                        child: Text('Product Name',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Container(alignment:Alignment.center,
                                                              width: 200,
                                                        child: Text('Good Quty',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Container(alignment:Alignment.center,
                                                              width: 200,
                                                        child: Text(
                                                            'Rejected Qty',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Container(alignment:Alignment.center,
                                                              width: 200,
                                                        child: Text('Rework ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Container(alignment:Alignment.center,
                                                              width: 100,
                                                        child: Text('Edit Entries',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                  width: double.infinity,
                                                  height: 210,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: recentActivity
                                                        ?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final data =
                                                          recentActivity?[
                                                              index];
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300)),
                                                          color: index % 2 ==
                                                                  0
                                                              ? Colors.grey
                                                                  .shade50
                                                              : Colors.grey
                                                                  .shade100,
                                                        ),
                                                        height: 80,
                                                        width:
                                                            double.infinity,
                                                        child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(alignment:Alignment.center,
                                                              width: 100,
                                                              child: Text(
                                                                ' ${index + 1}  ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700),
                                                              ),
                                                            ),
                                                            Container(alignment:Alignment.center,
                                                              width: 200,
                                                              child: Text(
                                                                ' ${data?.ipdtotime ?? ''}  ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700),
                                                              ),
                                                            ),
                                                            Container(alignment:Alignment.center,
                                                              width: 200,
                                                              child: Text(
                                                                ' ${data?.ipditemid ?? ''}  ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700),
                                                              ),
                                                            ),
                                                            Container(alignment:Alignment.center,
                                                              width: 200,
                                                              child: Text(
                                                                '  ${data?.ipdgoodqty ?? ''} ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700),
                                                              ),
                                                            ),
                                                            Container(alignment:Alignment.center,
                                                              width: 200,
                                                              child: Text(
                                                                '  ${data?.ipdrejqty ?? ''}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700),
                                                              ),
                                                            ),
                                                            Container(alignment:Alignment.center,
                                                              width: 200,
                                                              child: Text(
                                                                '  ${data?.ipdreworkflag ?? ''} ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700),
                                                              ),
                                                            ),
                                                            Container(alignment:Alignment.center,
                                                              width: 100,
                                                              child:
                                                                  IconButton(
                                                                onPressed:
                                                                    () {
                                                                  updateproduction(
                                                                      widget
                                                                          .processid);
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .edit,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Center(
                                              child:
                                                  Text("No data available"),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
