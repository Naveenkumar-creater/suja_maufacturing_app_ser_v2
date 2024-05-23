



import 'package:equatable/equatable.dart';

class ShiftStatusEntity extends Equatable {
  final ShiftStatusdetailEntity ?shiftStatusdetailEntity;

  ShiftStatusEntity({ this.shiftStatusdetailEntity,});
  
  @override
 
  List<Object?> get props => [];
}



class ShiftStatusdetailEntity {
    ShiftStatusdetailEntity({
        required this.psDeptId,
        required this.psShiftId,
        required this.psShiftStatus,
        required this.psOpenTime,
        required this.psId,
        required this.psMpmId,
        required this.shiftName,
        required this.psShiftDate,
        required this.psCloseTime,
    });

    final int? psDeptId;
    final int? psShiftId;
    final int? psShiftStatus;
    final String? psOpenTime;
    final int? psId;
    final int? psMpmId;
    final String? shiftName;
    final String? psShiftDate;
    final String? psCloseTime;
    
    @override
  // TODO: implement props
  List<Object?> get props => [psDeptId,psShiftId,psShiftStatus,psOpenTime];
    
    }