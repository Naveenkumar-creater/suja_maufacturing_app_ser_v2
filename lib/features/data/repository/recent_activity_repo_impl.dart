// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:suja/features/data/datasource/remote/recent_activity_datasource.dart';
import 'package:suja/features/data/model/recent_activity_model.dart';
import 'package:suja/features/domain/repository/recent_activity_repo.dart';


class RecentActivityRepositoryImpl implements RecentActivityRepository {
  final RecentActivityDatasource recentActivityDatasource;
  RecentActivityRepositoryImpl(
    this.recentActivityDatasource,
  );


  @override
  Future<RecentActivitiesModel> getRecentActivity(int id, String token) async{
 RecentActivitiesModel modelresult =
        await recentActivityDatasource.getRecentActivity(id, token);
    return modelresult;
  }
}
