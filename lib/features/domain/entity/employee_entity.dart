import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final List<ListofEmployeeEntity>? listofEmployeeEntity;

  const EmployeeEntity({this.listofEmployeeEntity});

  @override
  List<Object?> get props => [listofEmployeeEntity];
}

class ListofEmployeeEntity extends Equatable {
  const ListofEmployeeEntity( {
    required this.processName,
    required this.empPersonid,
    required this.processId,
    required this.personFname,
    required this.timing,
    required this.emp_mgr,
    //required this.productId,
    required this.productQty,
    required this.productName,
    //required this.attendance,
    required this.attendanceid,
    required this.flattdate,
    required this.mfgpempid, 
    required this.flattstatus,
    // required this.shifId, 
    required this.itemId,
    // required this.shitStatus,
  });

  final int? empPersonid;
  final int?  processId;
  final String? personFname;
  final String? timing;
  final int? emp_mgr;
  final String ? attendanceid;
  //final int? productId;
  final String ? productQty;
  final String? productName;
  //final int? attendance;
  final String? flattdate;
  final int? mfgpempid;
  final int?flattstatus;
  final String? processName;
    // final int?  shifId;
    // final int? shitStatus;
      final String? itemId;
  @override
  List<Object?> get props => [
        empPersonid,
        processId,
        personFname,
        timing,
        emp_mgr,
        // shifId,
        itemId,
        // shitStatus,
        //productId,
        productQty,
        productName,
        //attendance,
        attendanceid,
        flattdate,
        flattstatus,
        mfgpempid,
      ];

  get index => null;

  // Method to update the employee ID
  ListofEmployeeEntity updateEmpPersonId(int newEmpPersonId) {
    return ListofEmployeeEntity(
      empPersonid: newEmpPersonId,
      processId: processId,
      personFname: personFname,
      timing: timing,
      emp_mgr: emp_mgr,
      productName: productName,
      attendanceid: attendanceid,
      flattdate: flattdate,
      mfgpempid: mfgpempid, flattstatus: flattstatus,
      processName: processName,
      productQty:productQty,
      // shifId: shifId,
      // shitStatus: shitStatus,
      itemId: itemId
    );
  }
}
