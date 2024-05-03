import 'package:suja/features/data/model/attendance_count.dart';
import 'package:suja/features/domain/entity/attendance_count_entity.dart';
import 'package:suja/features/domain/repository/attendance_count_repository.dart';

import '../datasource/remote/attendance_count_datasource.dart';

class AttendanceCountRepositoryImpl extends AttendanceCountRepository {
  final AttendanceCountDataSOurce attendanceCountDataSOurce;

  AttendanceCountRepositoryImpl(this.attendanceCountDataSOurce);

  @override
  Future<AttendanceCountModel> getAttCount(int id, String token) async {
    AttendanceCountModel result =
        await attendanceCountDataSOurce.getAttCount(id, token);
    return result;
  }
}
