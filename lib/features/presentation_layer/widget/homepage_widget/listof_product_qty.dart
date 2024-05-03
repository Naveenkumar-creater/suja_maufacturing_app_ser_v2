import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class ListofProductQuantity extends StatelessWidget {
  const ListofProductQuantity
({super.key});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Container(
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
                          headingTextStyle: const TextStyle(color: Colors.white),
                          dataTextStyle: const TextStyle(color: Colors.black),
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => const Color(0xFF1a1f3c)),
                          dataRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey.shade100),
            columns: [
              DataColumn2(
                label: Center(child: Text('Product')), 
              ),
              DataColumn(
                label: Center(child: Text('Planned Qty')),
              ),
              DataColumn(
                label: Center(child: Text('Produced Qty')),
              ),
            ],
            rows: List<DataRow>.generate(
                100,
                (index) => DataRow(
                  color: MaterialStateColor.resolveWith((states) => index%2==0? Colors.white: Colors.grey.shade100),
                  cells: [
                      DataCell(Center(child: Text("O ring"))),
                      DataCell(Center(child: Text('500'))),
                      DataCell(Center(child: Text('250'))),
                    ]))),
      ),
      ),
    );
  }
}
