// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:prominous/features/data/model/allocation_model.dart';

class ActivityEntity extends Equatable {
  final List<ActivityProductList>? activityEntity;
  const ActivityEntity({this.activityEntity});

  @override
  List<Object?> get props => [activityEntity];
}

class ActivityProductList extends Equatable {
  const ActivityProductList({
  required this.paActivityName,
    // required this.productname,
    required this.paId,
    required this.paMpmId
  });
  final String? paActivityName;
    final int? paId;
    final int? paMpmId;
  @override
  List<Object?> get props => [ paActivityName, paId,paMpmId];
}
