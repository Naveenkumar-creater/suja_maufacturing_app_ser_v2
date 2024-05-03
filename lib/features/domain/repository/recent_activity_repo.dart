import 'package:suja/features/domain/entity/recent_activity_entity.dart';

abstract class RecentActivityRepository {
  Future<RecentActivitiesEntity> getRecentActivity(int id, String token);
}
