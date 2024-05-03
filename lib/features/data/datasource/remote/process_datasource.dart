// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:suja/constant/request_model.dart';
import 'package:suja/features/data/model/process_model.dart';

import '../../core/process_client.dart';

abstract class ProcessDatasource {
  Future<ProcessModel> getProcessList(String token);
}

class ProcessDatasourceImpl implements ProcessDatasource {
  ProcessClient processClient;
  ProcessDatasourceImpl(
    this.processClient,
  );
  @override
  Future<ProcessModel> getProcessList(String token) async {
    final response = await processClient.getProcessList(token);

    final result = ProcessModel.fromJson(response);

    return result;
  }
}
