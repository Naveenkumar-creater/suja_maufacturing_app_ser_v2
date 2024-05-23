import '../entity/emp_production_entity.dart';
import '../repository/emp_production_repository.dart';

class EmpProductionEntryUsecases {
  final EmpProductionRepository empProductionRepository;

  EmpProductionEntryUsecases(this.empProductionRepository);

  Future<EmpProductionEntity> execute(int empid,int deptid,int psid, String token
      //int goodQuantities, int rejectedQuantities, int reworkQuantities
      ) {
    return empProductionRepository.getempproduction(empid,deptid,psid, token
        //,goodQuantities, rejectedQuantities, reworkQuantities
        );
  }
}
