import 'package:suja/features/domain/entity/attendance_count_entity.dart';

abstract class AttendanceCountRepository {
  Future<AttendanceEntity> getAttCount(int id, String token);
}
