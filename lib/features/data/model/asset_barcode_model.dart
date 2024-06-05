

import 'package:prominous/features/domain/entity/scan_asset_barcode_entity.dart';

class ScanAssetBarcodeModel extends ScanAssetBarcodeEntity {
    ScanAssetBarcodeModel({
        required this.scanAssetId,
    }):super(scanAseetBarcode:scanAssetId );

    final ScanAssetId? scanAssetId;

    factory ScanAssetBarcodeModel.fromJson(Map<String, dynamic> json){ 
        return ScanAssetBarcodeModel(
            scanAssetId: json["response_data"]["Scan_Asset_Id"] == null ? null : ScanAssetId.fromJson(json["response_data"]["Scan_Asset_Id"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "Scan_Asset_Id": scanAssetId?.toJson(),
    };

}

class ScanAssetId extends ScanAseetBarcode{
    ScanAssetId({
        required this.pamId,
        required this.pamAssetId,
        required this.pamPaId,
        required this.pamMpmId,
    }) : super(pamId: pamId, pamAssetId: pamAssetId, pamPaId: pamPaId, pamMpmId: pamMpmId);

    final int? pamId;
    final int? pamAssetId;
    final int? pamPaId;
    final int? pamMpmId;

    factory ScanAssetId.fromJson(Map<String, dynamic> json){ 
        return ScanAssetId(
            pamId: json["pam_id"],
            pamAssetId: json["pam_asset_id"],
            pamPaId: json["pam_pa_id"],
            pamMpmId: json["pam_mpm_id"],
        );
    }

    Map<String, dynamic> toJson() => {
        "pam_id": pamId,
        "pam_asset_id": pamAssetId,
        "pam_pa_id": pamPaId,
        "pam_mpm_id": pamMpmId,
    };

}
