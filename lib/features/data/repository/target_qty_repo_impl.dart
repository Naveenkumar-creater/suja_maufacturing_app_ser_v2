import 'package:suja/features/data/datasource/remote/target_qty_datasource.dart';
import 'package:suja/features/data/model/target_qty_model.dart';
import 'package:suja/features/domain/entity/target_qty_entity.dart';
import 'package:suja/features/domain/repository/target_qty_repo.dart';

class TargetQtyRepoImpl implements TargetQtyRepository {
  TargetQtyDatasourceImpl targetQtyDatasource = TargetQtyDatasourceImpl();

  TargetQtyRepoImpl(TargetQtyDatasourceImpl targetQtyDatasourceImpl);
  @override
  Future<TargetQtyModel> getTargetQty(
     int paId,int deptid,int psid, int itemid,
    String token,) async {
    TargetQtyModel result =
        await targetQtyDatasource.getTargetQty(paId,deptid,psid,itemid ,token);
    return result;
  }
}
