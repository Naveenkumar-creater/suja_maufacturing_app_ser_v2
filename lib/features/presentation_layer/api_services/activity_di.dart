import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja/constant/show_pop_error.dart';
import 'package:suja/features/data/datasource/remote/activity_datasource.dart';
import 'package:suja/features/data/repository/activity_repo_impl.dart';

import 'package:suja/features/domain/usecase/activity_usecase.dart';
import 'package:suja/features/presentation_layer/provider/activity_provider.dart';


class ActivityService {
  Future<void> getActivity(
      {required BuildContext context, required int id}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";



         final recentActivityUseCase = ActivityUsecase(
        ActivityRepositoryImpl(
          ActivityDatasourceImpl(),
        ),
      );

      final user = await recentActivityUseCase.execute(id, token);

      Provider.of<ActivityProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
