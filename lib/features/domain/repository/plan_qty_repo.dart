import 'package:suja/features/domain/entity/plan_qty_entity.dart';

abstract class PlanQtyRepository{
  Future<PlanQtyEntity> getPlanQty(int id,String token);
}