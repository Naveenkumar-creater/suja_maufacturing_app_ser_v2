import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final emp_mgr = Provider.of<EmployeeProvider>(context, listen: true)
        .user
        ?.listofEmployeeEntity
        ?.first
        .emp_mgr;
    return Scaffold(
      // backgroundColor: defaultBackgroundColor,
      //appBar: myAppBar,
      drawer: MyDrawer(
          //emp_mgr: emp_mgr!,
          ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // first 4 boxes in grid
            AspectRatio(
              aspectRatio: 1,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  itemBuilder: (context, index) {
                    return EmployeeDetailsList(
                 
                      deptid: 1057,
                    );
                  },
                ),
              ),
            ),

            // list of previous days
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 4,
            //     itemBuilder: (context, index) {
            //       return const ProductListQty();
            //       //const MyTile();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
