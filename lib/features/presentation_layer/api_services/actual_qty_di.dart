import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja/constant/show_pop_error.dart';
import 'package:suja/features/data/datasource/remote/actual_qty_datasource.dart';
import 'package:suja/features/data/repository/actual_qty_repo_impl.dart';
import 'package:suja/features/domain/entity/actual_qty_entity.dart';
import 'package:suja/features/domain/repository/actual_qty_repo.dart';


import 'package:suja/features/domain/usecase/actual_qty_usecase.dart';

import 'package:suja/features/presentation_layer/provider/actual_qty_provider.dart';


class ActualQtyService {
  Future<void> getActualQty(
      {required BuildContext context, required int id}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      String token = pref.getString("client_token") ?? "";
       ActualQtyDatasource empData = ActualQtyDatasourceImpl();
      ActualQtyRepository allocationRepository =
          ActualQtyRepositoryImpl(empData);
      ActualQtyUsecase empUseCase = ActualQtyUsecase(allocationRepository);
      //    final recentActivityUseCase = ActualQtyUsecase(
      //   ActualQtyRepositoryImpl(
      //     ActualQtyDatasourceImpl(),
      //   ),
      // );

      ActualQtyEntity user = await empUseCase.execute(id, token);

      Provider.of<ActualQtyProvider>(context, listen: false).setUser(user);

    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
