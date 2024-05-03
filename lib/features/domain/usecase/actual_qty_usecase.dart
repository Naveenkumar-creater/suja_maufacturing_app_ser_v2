import 'package:suja/features/domain/entity/actual_qty_entity.dart';
import 'package:suja/features/domain/repository/actual_qty_repo.dart';

class ActualQtyUsecase{

  final ActualQtyRepository actualQtyRepository;
  ActualQtyUsecase(this.actualQtyRepository);

  Future<ActualQtyEntity>execute(int id,String token)async{
return actualQtyRepository.getActualQty(id, token);
  }
}