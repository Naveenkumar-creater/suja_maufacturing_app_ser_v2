import 'package:suja/features/data/datasource/remote/emp_production_entry_datasourcel.dart';

import 'package:suja/features/domain/repository/emp_production_repository.dart';

import '../../domain/entity/emp_production_entity.dart';

class EmpProductionEntryRepoImpl implements EmpProductionRepository {
  final EmpProductionEntryDatasource empProductionEntryDatasource;

  EmpProductionEntryRepoImpl(this.empProductionEntryDatasource);

  @override
  Future<EmpProductionEntity> getempproduction(
    int empid,
    int deptid,int psid,
    String token,
    // int goodQuantities, int rejectedQuantities, int reworkQuantities
  ) {
    final result = empProductionEntryDatasource.getempproduction(empid,deptid,psid,token
        // , goodQuantities, rejectedQuantities, reworkQuantities
        );
    return result;
  }
}
