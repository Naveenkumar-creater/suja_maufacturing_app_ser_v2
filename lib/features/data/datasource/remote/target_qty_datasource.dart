import 'package:suja/features/data/model/target_qty_model.dart';

import '../../../../constant/request_model.dart';
import '../../core/api_constant.dart';



abstract class TargetQtyDatasource {
  Future<TargetQtyModel> getTargetQty(int paId, int shiftId, String token);
}

class TargetQtyDatasourceImpl extends TargetQtyDatasource {
  // final AllocationClient allocationClient;

  // RecentActivityDatasourceImpl(this.allocationClient);
  @override
  Future<TargetQtyModel> getTargetQty(int paId, int shiftId, String token) async {
    // final response = await allocationClient.getallocation(id, token);

    // final result = AllocationModel.fromJson(response);

    // return result;

      ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "target_qty", clientAuthToken: token, paId: paId,shiftId: shiftId);
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = TargetQtyModel.fromJson(response);
      print(result);
      return result;
  }
}
