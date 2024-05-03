// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:suja/constant/request_model.dart';
import 'package:suja/features/data/core/api_constant.dart';
import 'package:suja/features/data/model/card_no_model.dart';


abstract class CardNoDatasource {
  Future<CardNoModel> getCardNo(String token,int cardNo);
}

class CardNoDatasourceImpl implements CardNoDatasource {

  @override
  Future<CardNoModel> getCardNo(String token,int cardNo) async {
    ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "scan_card_for_item", clientAuthToken: token, cardNo: cardNo);
    final response = await ApiConstant.scannerApiRequest(requestBody:requestbody);

    final result = CardNoModel.fromJson(response);

    return result;
  }
}
