import 'package:suja/features/domain/entity/employee_entity.dart';
import 'package:suja/features/domain/entity/product_entity.dart';


abstract class EmployeeRepository{
  Future<EmployeeEntity>getEmployeeList(int id,int shiftid,String token);
}