import '../entity/emp_production_entity.dart';
import '../repository/emp_production_repository.dart';

class EmpProductionEntryUsecases {
  final EmpProductionRepository empProductionRepository;

  EmpProductionEntryUsecases(this.empProductionRepository);

  Future<EmpProductionEntity> execute(int empid, String token
      //int goodQuantities, int rejectedQuantities, int reworkQuantities
      ) {
    return empProductionRepository.getempproduction(empid, token
        //,goodQuantities, rejectedQuantities, reworkQuantities
        );
  }
}
