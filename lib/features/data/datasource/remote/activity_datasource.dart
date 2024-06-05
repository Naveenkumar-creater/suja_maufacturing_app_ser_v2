import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/data/model/recent_activity_model.dart';

import '../../../../constant/request_model.dart';
import '../../core/api_constant.dart';

abstract class ActivityDatasource {
  Future<ActivityModel> getActivity(int id, int deptid,String token);
}

class ActivityDatasourceImpl extends ActivityDatasource {
  // final AllocationClient allocationClient;

  // ActivityDatasourceImpl(this.allocationClient);
  
  
  @override
  Future<ActivityModel> getActivity(int id,int deptid, String token) async{
   ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "process_activity", clientAuthToken: token, processId: id,deptId: deptid);
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = ActivityModel.fromJson(response);
      print(result);
      return result;
  }
  
}
