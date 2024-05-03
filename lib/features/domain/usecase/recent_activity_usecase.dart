import 'package:suja/features/domain/entity/AllocationEntity.dart';
import 'package:suja/features/domain/entity/recent_activity_entity.dart';
import 'package:suja/features/domain/repository/allocation_repo.dart';
import 'package:suja/features/domain/repository/recent_activity_repo.dart';

class RecentActivityUsecase {
  final RecentActivityRepository recentActivityRepository;

  RecentActivityUsecase(this.recentActivityRepository);

  Future<RecentActivitiesEntity> execute(int id, String token) {
    return recentActivityRepository.getRecentActivity(id, token);
  }
}