import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja/constant/show_pop_error.dart';
import 'package:suja/features/data/datasource/remote/attendance_count_datasource.dart';
import 'package:suja/features/data/repository/attendance_count_repository_impl.dart';
import 'package:suja/features/domain/usecase/attendance_count.dart';
import 'package:suja/features/presentation_layer/provider/attendance_count_provider.dart';

class AttendanceCountService {
  Future<void> getAttCount({required BuildContext context, required id}) async {
    try {
      SharedPreferences shref = await SharedPreferences.getInstance();
      String token = shref.getString("client_token") ?? "";
      final attendanceCountUseCases = AttendanceCountUseCases(
          AttendanceCountRepositoryImpl(AttendanceCountDataSOurceImpl()));

      final user = await attendanceCountUseCases.execute(id, token);

      Provider.of<AttendanceCountProvider>(context, listen: false)
          .setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
