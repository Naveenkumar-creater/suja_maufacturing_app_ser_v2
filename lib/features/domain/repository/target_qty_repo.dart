import 'package:prominous/features/domain/entity/actual_qty_entity.dart';
import 'package:prominous/features/domain/entity/target_qty_entity.dart';

abstract class TargetQtyRepository{
  Future<TargetQtyEntity> getTargetQty( int paId,int empid,int deptid,int psid, 
    String token);

}