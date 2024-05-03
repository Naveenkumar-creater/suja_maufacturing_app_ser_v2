
import 'package:suja/features/data/core/allocation_client.dart';
import 'package:suja/features/data/model/allocation_model.dart';

abstract class AllocationDatasource {
  Future<AllocationModel> getallocation(int id, String token);
}

class AllocationDatasourceImpl extends AllocationDatasource {
  final AllocationClient allocationClient;

  AllocationDatasourceImpl(this.allocationClient);
  @override
  Future<AllocationModel> getallocation(int id, String token) async {
    final response = await allocationClient.getallocation(id, token);

    final result = AllocationModel.fromJson(response);

    return result;

    //   ApiRequestDataModel requestbody = ApiRequestDataModel(
    //       apiFor: "allocation", clientAuthToken: token, emppersonid: id);
    //  final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    // final result = AllocationModel.fromJson(response);
    //   print(result);
    //   return result;
  }
}
