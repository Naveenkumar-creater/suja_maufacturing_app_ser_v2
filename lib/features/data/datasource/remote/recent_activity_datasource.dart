import 'package:suja/features/data/model/recent_activity_model.dart';

import '../../../../constant/request_model.dart';
import '../../core/api_constant.dart';

abstract class RecentActivityDatasource {
  Future<RecentActivitiesModel> getRecentActivity(int id, String token);
}

class RecentActivityDatasourceImpl extends RecentActivityDatasource {
  // final AllocationClient allocationClient;

  // RecentActivityDatasourceImpl(this.allocationClient);
  @override
  Future<RecentActivitiesModel> getRecentActivity(int id, String token) async {
    // final response = await allocationClient.getallocation(id, token);

    // final result = AllocationModel.fromJson(response);

    // return result;

      ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "recent_activities", clientAuthToken: token, emppersonid: id);
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = RecentActivitiesModel.fromJson(response);
      print(result);
      return result;
  }
}
