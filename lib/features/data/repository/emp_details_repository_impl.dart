// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:suja/features/data/datasource/remote/emp_details_datasource.dart';
import 'package:suja/features/data/datasource/remote/process_datasource.dart';
import 'package:suja/features/domain/entity/emp_details_entity.dart';
import 'package:suja/features/domain/repository/process_repository.dart';
import '../../domain/entity/process_entity.dart';
import '../../domain/repository/emp_details_repository.dart';

class EmpDetailsRepositoryImpl implements EmpDetailsRepository {
  final EmpDetailsDatasource empDetailsDatasource;
  EmpDetailsRepositoryImpl(
    this.empDetailsDatasource,
  );
  @override
  Future<EmpDetailsEntity> getEmpDetails(String token) async {
    final result = await empDetailsDatasource.getEmpDetails(token);
    return result;
  }
}
