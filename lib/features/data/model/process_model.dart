import '../../domain/entity/process_entity.dart';

class ProcessModel extends ProcessEntity {
  const ProcessModel({
    required this.listOfProcess,
  }) : super(listofProcessEntity: listOfProcess);

  final List<ListOfProcess> listOfProcess;

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    final processListJson =
        json['response_data']['List_Of_Process']; // Updated key name
    // ignore: avoid_print
    // print('Process List: $processListJson'); // Print the processListJson

    if (processListJson == null) {
      throw Exception(
          'Asset list is null.'); // Throw an exception if asset list is null
    }

    final processData = (processListJson as List)
        .map((item) => ListOfProcess.fromJson(item))
        .toList();

    return ProcessModel(listOfProcess: processData);
  }

  Map<String, dynamic> toJson() => {
        "List_Of_Process": listOfProcess.map((x) => x?.toJson()).toList(),
      };
}

class ListOfProcess extends ListofProcessEntity {
  const ListOfProcess({
    required this.processName,
    required this.processId,
    required this.shiftid
  })  : assert(processId != null), // Ensure processId is not null
        super(processName: processName, processId: processId,shiftid:shiftid);

  final String? processName;
  final int? processId;
  final int? shiftid;

  factory ListOfProcess.fromJson(Map<String, dynamic> json) {
    return ListOfProcess(
      processName: json["process_name"],
      processId: json["process_Id"] != null ? json["process_Id"] : 0,
      shiftid:json["shift_id"]
    );
  }

  Map<String, dynamic> toJson() => {
        "process_name": processName,
        "process_Id": processId,
      };
}
