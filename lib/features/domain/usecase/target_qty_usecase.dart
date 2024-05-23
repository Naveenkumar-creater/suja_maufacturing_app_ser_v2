import 'package:suja/features/domain/entity/process_entity.dart';
import 'package:suja/features/domain/entity/target_qty_entity.dart';
import 'package:suja/features/domain/repository/process_repository.dart';
import 'package:suja/features/domain/repository/target_qty_repo.dart';

class TargetQtyUsecase {
  final TargetQtyRepository targetQtyRepository;
  TargetQtyUsecase(this.targetQtyRepository);

  Future<TargetQtyEntity> execute(
    int paId,int deptid,int psid, int itemid,
    String token,
  ) async {
    
    return targetQtyRepository.getTargetQty(paId,deptid,psid,itemid,token);
  }
}
