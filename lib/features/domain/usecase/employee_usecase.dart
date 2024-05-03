import 'package:suja/features/domain/entity/employee_entity.dart';
import 'package:suja/features/domain/repository/employee_repository.dart';

class EmployeeUsecase{
  final EmployeeRepository employeeRepository;
  EmployeeUsecase(this.employeeRepository);

  Future<EmployeeEntity>execute(int id,int shiftid, String token)async{
return  employeeRepository.getEmployeeList(id, shiftid,token);
  }
}