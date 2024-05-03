import '../../domain/entity/recent_activity_entity.dart';








class RecentActivitiesModel extends RecentActivitiesEntity{
   RecentActivitiesModel({required this.recentActivitiesList}) : super(recentActivitesEntityList:recentActivitiesList);

    final List<RecentActivitiesList> recentActivitiesList;

    factory RecentActivitiesModel.fromJson(Map<String, dynamic> json){ 
        return RecentActivitiesModel(
            recentActivitiesList: json['response_data']["List_Of_Recent_Activities"] == null ? [] : List<RecentActivitiesList>.from(json['response_data']["List_Of_Recent_Activities"]!.map((x) => RecentActivitiesList.fromJson(x))),
        );
    }

   


}


class RecentActivitiesList extends RecentActivitiesEntityList{

    final int? ipdCardNo;
    final int? ipdRejQty;
    final int? ipdGoodQty;
    final int? ipdEmpId;
    final DateTime? ipdToTime;
    final int? ipdItemId;
    final int? ipdReworkFlag;
    final DateTime? ipdFromTime;
    final int? ipdAssetId;

    RecentActivitiesList({
        required this.ipdCardNo,
        required this.ipdRejQty,
        required this.ipdGoodQty,
        required this.ipdEmpId,
        required this.ipdToTime,
        required this.ipdItemId,
        required this.ipdReworkFlag,
        required this.ipdFromTime,
        required this.ipdAssetId,
    }):super(ipdassetid: ipdAssetId,ipdcardno: ipdCardNo,ipdempid: ipdEmpId,ipdfromtime: ipdFromTime,ipdgoodqty: ipdGoodQty,ipditemid: ipdItemId,ipdrejqty: ipdRejQty,ipdreworkflag: ipdReworkFlag,ipdtotime: ipdToTime);

  

    factory RecentActivitiesList.fromJson(Map<String, dynamic> json){ 
        return RecentActivitiesList(
            ipdCardNo: json["ipd_card_no"],
            ipdRejQty: json["ipd_rej_qty"],
            ipdGoodQty: json["ipd_good_qty"],
            ipdEmpId: json["ipd_emp_id"],
            ipdToTime: DateTime.tryParse(json["ipd_to_time"] ?? ""),
            ipdItemId: json["ipd_item_id"],
            ipdReworkFlag: json["ipd_rework_flag"],
            ipdFromTime: DateTime.tryParse(json["ipd_from_time"] ?? ""),
            ipdAssetId: json["ipd_asset_id"],
        );
    }

    Map<String, dynamic> toJson() => {
        "ipd_card_no": ipdCardNo,
        "ipd_rej_qty": ipdRejQty,
        "ipd_good_qty": ipdGoodQty,
        "ipd_emp_id": ipdEmpId,
        "ipd_to_time": ipdToTime?.toIso8601String(),
        "ipd_item_id": ipdItemId,
        "ipd_rework_flag": ipdReworkFlag,
        "ipd_from_time": ipdFromTime?.toIso8601String(),
        "ipd_asset_id": ipdAssetId,
    };

}