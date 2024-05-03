import 'package:suja/features/domain/entity/attendance_count_entity.dart';

import '../repository/attendance_count_repository.dart';

class AttendanceCountUseCases {
  final AttendanceCountRepository attendanceCountRepository;

  AttendanceCountUseCases(this.attendanceCountRepository);
  Future<AttendanceEntity> execute(int id, String token) async {
    return await attendanceCountRepository.getAttCount(id, token);
  }
}
