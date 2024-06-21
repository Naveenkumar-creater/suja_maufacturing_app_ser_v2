import 'package:prominous/constant/request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/edit_entry_model.dart';

abstract class EditEntryDatasource {
  Future<EditEntryModel>getEditEntry(int ipdId, int empid,int psid, int deptid,String token);
}

class EditEntryDatasourceImpl implements EditEntryDatasource {
  @override
  Future<EditEntryModel> getEditEntry(int ipdId,int empid, int psid, int deptid,String token) async{
 ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "edit_entry",ipdid: ipdId, emppersonid:empid, psId:psid, deptId:deptid,clientAuthToken: token );
   final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
  EditEntryModel result= await EditEntryModel.  fromJson(response);
  print(result);
  return result;
  }
  
}