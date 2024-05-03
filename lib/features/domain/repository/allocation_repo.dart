import 'package:suja/features/domain/entity/AllocationEntity.dart';

abstract class AllocationRepository {
  Future<AllocationEntity> getallocation(int id, String token);
}
