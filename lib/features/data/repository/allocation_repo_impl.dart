// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:suja/features/data/datasource/remote/allocation_datasource.dart';
import 'package:suja/features/data/model/allocation_model.dart';

import '../../domain/repository/allocation_repo.dart';

class AllocationRepositoryImpl implements AllocationRepository {
  final AllocationDatasource allocationDatasource;
  AllocationRepositoryImpl(
    this.allocationDatasource,
  );
  @override
  Future<AllocationModel> getallocation(int id, String token) async {
    AllocationModel modelresult =
        await allocationDatasource.getallocation(id, token);

    return modelresult;
  }
}
