import 'package:prominous/features/domain/entity/activity_entity.dart';

class ActivityModel extends ActivityEntity{
    const ActivityModel({
        required this.activityProduct,
    }):super(activityEntity:activityProduct);

    final List<ActivityProduct> activityProduct;

    factory ActivityModel.fromJson(Map<String, dynamic> json){ 
        return ActivityModel(
            activityProduct: json["response_data"]["Allocation_Of_Product"] == null ? [] : List<ActivityProduct>.from(json["response_data"]["Allocation_Of_Product"]!.map((x) => ActivityProduct.fromJson(x))),
        );
    }

    // Map<String, dynamic> toJson() => {
    //     "Allocation_Of_Product": allocationOfProduct.map((x) => x?.toJson()).toList(),
    // };

}

class ActivityProduct extends ActivityProductList {
  ActivityProduct({
    required String paActivityName,
    required int paId,
    required int paMpmId,
  }) : super(paActivityName: paActivityName, paId: paId, paMpmId: paMpmId);

  factory ActivityProduct.fromJson(Map<String, dynamic> json) {
    return ActivityProduct(
      paActivityName: json["pa_activity_name"] as String? ?? '',
      paId: json["pa_id"] as int? ?? 0,
      paMpmId: json["pa_mpm_id"] as int? ?? 0,
    );
  }
}


