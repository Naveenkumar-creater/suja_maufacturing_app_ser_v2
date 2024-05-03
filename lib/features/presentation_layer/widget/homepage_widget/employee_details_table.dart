import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:suja/features/presentation_layer/widget/homepage_widget/employe_allocation_popup.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
class EmployeeDetailsTable extends StatefulWidget {
  const EmployeeDetailsTable({Key? key}) : super(key: key);

  @override
  State<EmployeeDetailsTable> createState() => _EmployeeDetailsTableState();
}

class _EmployeeDetailsTableState extends State<EmployeeDetailsTable> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String toDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable2(
            columnSpacing: 8,
            horizontalMargin: 12,
            dataRowHeight: 80,
            headingTextStyle: const TextStyle(color: Colors.white),
            dataTextStyle: const TextStyle(color: Colors.black),
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFF1a1f3c)),
            dataRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.grey.shade100),
            columns: [
               DataColumn(
                label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text('S.No'),
                ),
              ),
                DataColumn(
                label: Container(
                   
                  alignment: Alignment.centerLeft,
                  child: Text( 'Name'),
                ),
              ),
               DataColumn(
                label: Container(
                   
                  alignment: Alignment.centerLeft,
                  child: Text( 'Product'),
                ),
              ),
            DataColumn(
                label: Container(
                   
                  alignment: Alignment.centerLeft,
                  child: Text( 'Timing'),
                ),
              ),
            
              
              DataColumn(
                label: Center(child: Text('Attendance')),
              ),
              DataColumn(
                label: Center(child: Text('Allocation')),
              ),
              DataColumn(
                label: Center(child: Text('Product Qty')),
              ),
            ],
            rows: List<DataRow>.generate(
              50,
              (index) => DataRow(
                color: MaterialStateColor.resolveWith((states) =>
                    index % 2 == 0 ? Colors.white : Colors.grey.shade100),
                cells: [
                  DataCell(Container(
padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                    child: Text(
                      "1",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  )),
                    DataCell(Container(

                  alignment: Alignment.centerLeft,
                    child: Text(
                         "Naveen",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  )),
                        DataCell(Container(

                  alignment: Alignment.centerLeft,
                    child: Text(
                         'Gaskets',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  )),
                
                  
                  DataCell(Center(child: Text(toDate as String))),
                  DataCell(
                    Center(
                      child: ToggleSwitch(
                        minWidth: 80.0,
                        cornerRadius: 20.0,
                        activeBgColors: [
                          [Colors.red[800]!],
                          [Colors.green[800]!]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        labels: ['A', 'P'],
                        radiusStyle: true,
                        onToggle: (index) {
                          print('switched to: $index');
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: ElevatedButton(
                        child: Text("change"),
                        onPressed: () {
                          setState(() {
                            //EmployeeAllocationPopup.showAlertDialog(context);
                          });
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: ElevatedButton(
                        child: Text("Add"),
                        onPressed: () {
                          setState(() {
                            // EmployeeAllocationPopup.showAlertDialog(context);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

