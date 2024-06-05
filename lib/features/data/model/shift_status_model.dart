import 'package:prominous/features/domain/entity/shift_status_entity.dart';

class ShiftStatusModel extends ShiftStatusEntity {
    ShiftStatusModel({
        required this.shiftStatus,
    }):super(shiftStatusdetailEntity:shiftStatus);

    final ShiftStatus? shiftStatus;

    factory ShiftStatusModel.fromJson(Map<String, dynamic> json){ 
        return ShiftStatusModel(
            shiftStatus: json["response_data"]["Shift_Status"] == null ? null : ShiftStatus.fromJson(json["response_data"]["Shift_Status"]),
        );
    }

}

class ShiftStatus extends ShiftStatusdetailEntity {
    ShiftStatus({
        required this.psDeptId,
        required this.psShiftId,
        required this.psShiftStatus,
        required this.psOpenTime,
        required this.psId,
        required this.psMpmId,
        required this.shiftName,
        required this.psShiftDate,
        required this.psCloseTime,
    }):super(psDeptId: psDeptId,psCloseTime: psCloseTime,psId: psId,psMpmId: psMpmId,psOpenTime: psOpenTime,psShiftDate: psShiftDate,psShiftId: psShiftId,psShiftStatus: psShiftStatus,shiftName: shiftName);


    final int? psDeptId;
    final int? psShiftId;
    final int? psShiftStatus;
    final String? psOpenTime;
    final int? psId;
    final int? psMpmId;
    final String? shiftName;
    final String? psShiftDate;
    final String? psCloseTime;

    factory ShiftStatus.fromJson(Map<String, dynamic> json){ 
        return ShiftStatus(
            psDeptId: json["ps_dept_id"],
            psShiftId: json["ps_shift_id"],
            psShiftStatus: json["ps_shift_status"],
            psOpenTime: json["ps_open_time"],
            psId: json["ps_id"],
            psMpmId: json["ps_mpm_id"],
            shiftName: json["shift_name"],
            psShiftDate: json["ps_shift_date"],
            psCloseTime: json["ps_close_time"],
        );
    }

}
