import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suja/features/presentation_layer/page/loginpage.dart';
import 'package:suja/features/presentation_layer/provider/activity_provider.dart';
import 'package:suja/features/presentation_layer/provider/actual_qty_provider.dart';
import 'package:suja/features/presentation_layer/provider/asset_barcode_provier.dart';
import 'package:suja/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:suja/features/presentation_layer/provider/card_no_provider.dart';
import 'package:suja/features/presentation_layer/provider/emp_details_provider.dart';
import 'package:suja/features/presentation_layer/provider/emp_production_entry_provider.dart';
import 'package:suja/features/presentation_layer/provider/employee_provider.dart';
import 'package:suja/features/presentation_layer/provider/plan_qty_provider.dart';
import 'package:suja/features/presentation_layer/provider/process_provider.dart';
import 'package:suja/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:suja/features/presentation_layer/provider/target_qty_provider.dart';
import 'features/presentation_layer/provider/allocation_provider.dart';
import 'features/presentation_layer/provider/login_provider.dart';
import 'features/presentation_layer/provider/product_provider.dart';
import 'features/presentation_layer/provider/recent_activity_provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<ProcessProvider>(
          create: (_) => ProcessProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<EmployeeProvider>(
          create: (_) => EmployeeProvider(),
        ),
        ChangeNotifierProvider<AllocationProvider>(
          create: (_) => AllocationProvider(),
        ),
        ChangeNotifierProvider<EmpProductionEntryProvider>(
          create: (_) => EmpProductionEntryProvider(),
        ),
        ChangeNotifierProvider<EmpDetailsProvider>(
          create: (_) => EmpDetailsProvider(),
        ),
          ChangeNotifierProvider<RecentActivityProvider>(
          create: (_) => RecentActivityProvider(),
        ),
        ChangeNotifierProvider<ActivityProvider>(
          create: (_) => ActivityProvider(),
        ),
          ChangeNotifierProvider<ActualQtyProvider>(
          create: (_) => ActualQtyProvider(),
        ),
         ChangeNotifierProvider<AttendanceCountProvider>(
          create: (_) => AttendanceCountProvider(),
        ),
         ChangeNotifierProvider<PlanQtyProvider>(
          create: (_) => PlanQtyProvider(), 
        ),
            ChangeNotifierProvider<AssetBarcodeProvider>(
          create: (_) => AssetBarcodeProvider(),),
            ChangeNotifierProvider<CardNoProvider>(
          create: (_) => CardNoProvider(),),

           ChangeNotifierProvider<TargetQtyProvider>(
          create: (_) => TargetQtyProvider(),),
 ChangeNotifierProvider<ShiftStatusProvider>(
          create: (_) => ShiftStatusProvider(),)

          
        
      ],
      child: MaterialApp(
          title: 'Suja Manufacturing',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 45, 54, 104)),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const LoginPage()),
    );
  }
}
