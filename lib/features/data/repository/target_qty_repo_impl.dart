import 'package:prominous/features/data/datasource/remote/target_qty_datasource.dart';
import 'package:prominous/features/data/model/target_qty_model.dart';
import 'package:prominous/features/domain/entity/target_qty_entity.dart';
import 'package:prominous/features/domain/repository/target_qty_repo.dart';

class TargetQtyRepoImpl implements TargetQtyRepository {
  TargetQtyDatasourceImpl targetQtyDatasource = TargetQtyDatasourceImpl();

  TargetQtyRepoImpl(TargetQtyDatasourceImpl targetQtyDatasourceImpl);
  @override
  Future<TargetQtyModel> getTargetQty(
     int paId,int empid,int deptid,int psid, 
    String token) async {
    TargetQtyModel result =
        await targetQtyDatasource.getTargetQty(paId,empid,deptid,psid,token);
    return result;
  }
}
