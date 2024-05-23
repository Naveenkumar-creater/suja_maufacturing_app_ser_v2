import 'package:suja/features/domain/entity/actual_qty_entity.dart';
import 'package:suja/features/domain/entity/target_qty_entity.dart';

abstract class TargetQtyRepository{
  Future<TargetQtyEntity> getTargetQty( int paId,int deptid,int psid, int itemid,
    String token,);

}