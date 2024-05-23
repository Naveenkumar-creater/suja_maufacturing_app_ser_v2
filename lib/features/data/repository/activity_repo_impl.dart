import 'package:suja/features/data/datasource/remote/activity_datasource.dart';
import 'package:suja/features/data/model/activity_model.dart';

import 'package:suja/features/domain/repository/activity_repo.dart';

class ActivityRepositoryImpl extends ActivityRepository{
  final  ActivityDatasource activityDatasource;
  ActivityRepositoryImpl(this.activityDatasource);

  @override
  Future<ActivityModel> getActivity(int id, int deptid,String token) async{
 ActivityModel result= await activityDatasource.getActivity(id, deptid,token);
    return result;
  }
  
}