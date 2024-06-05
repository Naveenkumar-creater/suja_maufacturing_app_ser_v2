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

class ActivityProduct extends ActivityProductList{
    ActivityProduct({
        required this.paActivityName,
        required this.paId,
        required this.paMpmId,
    }) : super(paActivityName:paActivityName , paId: paId, paMpmId: paMpmId);

    final String? paActivityName;
    final int? paId;
    final int? paMpmId;

    factory ActivityProduct.fromJson(Map<String, dynamic> json){ 
        return ActivityProduct(
            paActivityName: json["pa_activity_name"],
            paId: json["pa_id"],
            paMpmId: json["pa_mpm_id"],
        );
    }

    // Map<String, dynamic> toJson() => {
    //     "pa_activity_name": paActivityName,
    //     "pa_id": paId,
    //     "pa_mpm_id": paMpmId,
    // };

}
