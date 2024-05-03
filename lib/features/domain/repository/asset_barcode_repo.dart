import 'package:suja/features/domain/entity/scan_asset_barcode_entity.dart';

abstract class AssetBarcodeRepository{
  
    Future<ScanAssetBarcodeEntity> getAssetBarcode(int processid,int assetId, String token);
}