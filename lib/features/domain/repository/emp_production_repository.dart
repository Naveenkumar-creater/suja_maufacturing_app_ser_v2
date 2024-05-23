import '../entity/emp_production_entity.dart';

abstract class EmpProductionRepository {
  Future<EmpProductionEntity> getempproduction(int empid,int deptid,int psid, String token
      // ,int goodQuantities, int rejectedQuantities, int reworkQuantities
      );
}
