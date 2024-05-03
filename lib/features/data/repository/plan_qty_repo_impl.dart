
import 'package:suja/features/data/datasource/remote/plan_qty_datasource.dart';

import 'package:suja/features/data/model/plan_qty_model.dart';

import 'package:suja/features/domain/repository/plan_qty_repo.dart';

class PlanQtyRepositoryImpl extends PlanQtyRepository{
  final  PlanQtyDatasource planQtyDatasource;
  PlanQtyRepositoryImpl(this.planQtyDatasource); 

  @override
  Future<PlanQuantityModel> getPlanQty(int id, String token) async{
   PlanQuantityModel result= await planQtyDatasource.getPlanQty(id, token);
    return result;
  }

  
}