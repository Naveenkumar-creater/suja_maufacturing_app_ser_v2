import 'package:suja/features/data/datasource/remote/activity_datasource.dart';
import 'package:suja/features/data/datasource/remote/actual_qty_datasource.dart';
import 'package:suja/features/data/model/activity_model.dart';
import 'package:suja/features/data/model/actual_qty_model.dart';
import 'package:suja/features/domain/entity/activity_entity.dart';

import 'package:suja/features/domain/repository/activity_repo.dart';
import 'package:suja/features/domain/repository/actual_qty_repo.dart';

class ActualQtyRepositoryImpl extends ActualQtyRepository{
  final  ActualQtyDatasource actualQtyDatasource;
  ActualQtyRepositoryImpl(this.actualQtyDatasource); 

  @override
  Future<ActualQuantityModel> getActualQty(int id, String token) async{
   ActualQuantityModel result= await actualQtyDatasource.getActualQty(id, token);
    return result;
  }

  
}