import 'package:prominous/features/domain/entity/process_entity.dart';
import 'package:prominous/features/domain/entity/target_qty_entity.dart';
import 'package:prominous/features/domain/repository/process_repository.dart';
import 'package:prominous/features/domain/repository/target_qty_repo.dart';

class TargetQtyUsecase {
  final TargetQtyRepository targetQtyRepository;
  TargetQtyUsecase(this.targetQtyRepository);

  Future<TargetQtyEntity> execute(
    int paId,int empid,int deptid,int psid, 
    String token,
  ) async {
    
    return targetQtyRepository.getTargetQty(paId,empid,deptid,psid,token);
  }
}
