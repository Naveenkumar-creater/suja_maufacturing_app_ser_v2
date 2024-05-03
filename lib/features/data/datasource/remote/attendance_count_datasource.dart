import 'package:suja/constant/request_model.dart';
import 'package:suja/features/data/core/api_constant.dart';
import 'package:suja/features/data/model/attendance_count.dart';

abstract class AttendanceCountDataSOurce {
  Future<AttendanceCountModel> getAttCount(int id, String token);
}

class AttendanceCountDataSOurceImpl extends AttendanceCountDataSOurce {
  @override
  Future<AttendanceCountModel> getAttCount(int id, String token) async {
    ApiRequestDataModel requestBody = ApiRequestDataModel(
        apiFor: "attendance_count", clientAuthToken: token, processId: id);
    final response =
        await ApiConstant.loginApiRequest(requestBody: requestBody);
    final result = AttendanceCountModel.fromJson(response);
    return result;
  }
}
