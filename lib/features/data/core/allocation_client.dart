import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../../constant/request_model.dart';
import 'api_constant.dart';

class AllocationClient {
  dynamic getallocation(int id, String token) async {
    ApiRequestDataModel requestData = ApiRequestDataModel(
        apiFor: "allocation", emppersonid: id, clientAuthToken: token);

    return await ApiConstant.makeApiRequest(requestBody: requestData);
  }
}
