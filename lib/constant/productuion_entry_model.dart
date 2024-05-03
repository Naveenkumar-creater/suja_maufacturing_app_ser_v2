class ProductionEntryReqModel {
    ProductionEntryReqModel({
      required this.apiFor,
      required this.clientAuthToken,
        required this.ipdMpmId,
        required this.ipdToTime,
        required this.ipdReworkFlag,
        required this.ipdAssetId,
        required this.ipdCardNo,
        required this.ipdRejQty,
        required this.ipdDeptId,
        required this.ipdDate,
        required this.ipdGoodQty,
        required this.ipdItemId,
        required this.ipdId,
        required this.ipdFromTime,
        required this.ipdPcId,
        // required this.mpmBatchProcess,
        required this.emppersonId,
        required this.ipdpaid
    });
      final String? apiFor;
  final String?clientAuthToken;
    final int? ipdMpmId;
    final String? ipdToTime;
    final int? ipdReworkFlag;
    final int? ipdAssetId;
    final int? ipdCardNo;
    final int? ipdRejQty;
    final int? ipdDeptId;
    final String? ipdDate;
    final int? ipdGoodQty;
    final int? ipdItemId;
    final int? ipdId;
    final String? ipdFromTime;
    final int? ipdPcId;
    // final int? mpmBatchProcess;
    final int? emppersonId;
    final int?  ipdpaid;
    // factory ProductionEntryReqModel.fromJson(Map<String, dynamic> json){ 
    //     return ProductionEntryReqModel(
    //         ipdMpmId: json["ipd_mpm_id"],
    //         ipdToTime: json["ipd_to_time"],
    //         ipdReworkFlag: json["ipd_rework_flag"],
    //         ipdAssetId: json["ipd_asset_id"],
    //         ipdCardNo: json["ipd_card_no"],
    //         ipdRejQty: json["ipd_rej_qty"],
    //         ipdDeptId: json["ipd_dept_id"],
    //         ipdDate: json["ipd_date"],
    //         ipdGoodQty: json["ipd_good_qty"],
    //         ipdItemId: json["ipd_item_id"],
    //         ipdId: json["ipd_id"],
    //         ipdFromTime: json["ipd_from_time"],
    //         ipdPcId: json["ipd_pc_id"],
    //         mpmBatchProcess: json["mpm_batch_process"],
    //         personId: json["person_id"],
    //     );
    // }

    Map<String, dynamic> toJson() => {
      'client_aut_token': clientAuthToken,
      'api_for': apiFor,
        "ipd_mpm_id": ipdMpmId,
        "ipd_to_time": ipdToTime,
        "ipd_rework_flag": ipdReworkFlag,
        "ipd_asset_id": ipdAssetId,
        "ipd_card_no": ipdCardNo,
        "ipd_rej_qty": ipdRejQty,
        "ipd_dept_id": ipdDeptId,
        "ipd_date": ipdDate,
        "ipd_good_qty": ipdGoodQty,
        "ipd_item_id": ipdItemId,
        "ipd_id": ipdId,
        "ipd_from_time": ipdFromTime,
        "ipd_pc_id": ipdPcId,
        // "mpm_batch_process": mpmBatchProcess,
        "emp_personid": emppersonId,
          'ipd_pa_id':  ipdpaid
    };

}
