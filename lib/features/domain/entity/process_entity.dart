import 'package:equatable/equatable.dart';

class ProcessEntity extends Equatable {
  final List<ListofProcessEntity>? listofProcessEntity;

  const ProcessEntity({
    this.listofProcessEntity,
  });

  @override
  List<Object?> get props => [listofProcessEntity];
}

class ListofProcessEntity extends Equatable {
  const ListofProcessEntity(
      {required this.processName, required this.processId,required this.deptId,required this.shiftgroupId});

  final String? processName;
  final int? processId;
  final int? deptId;
  final int? shiftgroupId;

  @override
  List<Object?> get props => [processName, processId,deptId,shiftgroupId];
}
