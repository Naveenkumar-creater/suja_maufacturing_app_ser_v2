// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:suja/features/data/model/emp_production_model.dart';

class EmpProductionEntity extends Equatable {
  final ListOfEmpProductionEntity ? empProductionEntity;

  const EmpProductionEntity({this.empProductionEntity});

  @override
  List<Object?> get props => [empProductionEntity];
}

class   ListOfEmpProductionEntity extends Equatable {
  final int? ipdcardno;
  final int? ipdmpmid;
  final int? rejqty;
  final int? goodqty;
  final int? ipdid;
  final int? ipdpcid;
  final int? ipdassetid;
  final int? ipdflagid;
  final String? ipddate;
  final String? ipdfromtime;
  final String? ipdtotime;
  final int? itemid;
  final int? ipddeptid;
  final int?ipdpaid;
  const ListOfEmpProductionEntity(
      {required this.ipdcardno,
      required this.ipdmpmid,
      required this.rejqty,
      required this.goodqty,
      required this.ipdid,
      required this.ipdpcid,
      required this.ipdassetid,
      required this.ipdflagid,
      required this.ipddate,
      required this.ipdfromtime,
      required this.ipdtotime,
      required this.itemid,
      required this.ipddeptid, int? mpmbatchprocess, int? personid,
      
      required this.ipdpaid});

  @override
  List<Object?> get props => [
        ipdcardno,
        ipdmpmid,
        rejqty,
        goodqty,
        ipdid,
        ipdpcid,
        ipdassetid,
        ipdflagid,
        ipddate,
        ipdfromtime,
        ipdtotime,
        itemid,
        ipddeptid,
        ipdpaid
      ];

}
