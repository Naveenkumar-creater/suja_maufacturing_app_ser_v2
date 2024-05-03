import 'package:suja/features/data/model/employee_model.dart';
import '../../domain/repository/employee_repository.dart';
import '../datasource/remote/employee_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDatasource employeeDatasource;

  EmployeeRepositoryImpl(this.employeeDatasource);

  @override
  Future<EmployeeModel> getEmployeeList(int id,int shiftid, String token) async {
    final result = employeeDatasource.getEmployeeList(id,shiftid,token);
    return result;
  }
}
