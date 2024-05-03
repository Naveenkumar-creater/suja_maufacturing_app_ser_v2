
import 'package:suja/features/domain/entity/target_qty_entity.dart';


class TargetQtyModel extends TargetQtyEntity {
  TargetQtyModel({
    required this.targetQty,
  }) : super(targetQty: targetQty);

  final TargetQty? targetQty;

  factory TargetQtyModel.fromJson(Map<String, dynamic> json) {
    return TargetQtyModel(
      targetQty: json["response_data"]["Target_Qty"] == null 
          ? TargetQty(targetqty: 0) // Set default value if Actual_Qty is null
          : TargetQty.fromJson(json["response_data"]["Target_Qty"]),
    );
  }
}

class TargetQty extends TargetQty1 {
  TargetQty({
    required this.targetqty,
  }) : super(targetqty: targetqty ?? 0); // Ensure actualQty is not null

  final int? targetqty;

  factory TargetQty.fromJson(Map<String, dynamic> json) {
    return TargetQty(
      targetqty: json["target_Qty"] ?? 0, // Provide a default value if Actual_qty is null
    );
  }

 
}
