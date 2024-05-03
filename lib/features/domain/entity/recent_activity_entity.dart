import 'package:equatable/equatable.dart';



class RecentActivitiesEntity extends Equatable {
  final List<RecentActivitiesEntityList> ?recentActivitesEntityList;

  RecentActivitiesEntity({  this.recentActivitesEntityList,});
  
  @override
 
  List<Object?> get props => [];
}

class RecentActivitiesEntityList extends Equatable {
  final int? ipdcardno;
  final int? ipdrejqty;
  final int ?ipdgoodqty;
  final int ?ipdempid;
  final int ?ipditemid;
  final int ?ipdreworkflag;
  final int ?ipdassetid;
  final DateTime ?ipdfromtime;
  final DateTime ?ipdtotime;

  RecentActivitiesEntityList({
      required this.ipdcardno,
      required this.ipdrejqty,
      required this.ipdgoodqty,
      required this.ipdempid,
      required this.ipditemid,
      required this.ipdreworkflag,
      required this.ipdassetid,
      required this.ipdfromtime,
      required this.ipdtotime});

  @override
  List<Object?> get props => [
        ipdcardno,
        ipdrejqty,
        ipdgoodqty,
        ipdempid,
        ipditemid,
        ipdreworkflag,
        ipdassetid,
        ipdfromtime,
        ipdtotime
      ];
}
