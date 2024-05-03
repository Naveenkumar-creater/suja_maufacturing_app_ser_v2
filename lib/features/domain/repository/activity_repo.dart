import 'package:suja/features/domain/entity/activity_entity.dart';

abstract class ActivityRepository{
  Future<ActivityEntity>getActivity(int id,String token);
}