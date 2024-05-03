import 'package:suja/features/domain/entity/actual_qty_entity.dart';
import 'package:suja/features/domain/entity/scan_asset_barcode_entity.dart';
import 'package:suja/features/domain/repository/actual_qty_repo.dart';
import 'package:suja/features/domain/repository/asset_barcode_repo.dart';

class AssetBarcodeUsecase{

  final AssetBarcodeRepository assetBarcodeRepository;
  AssetBarcodeUsecase(this.assetBarcodeRepository);

  Future<ScanAssetBarcodeEntity>execute(int processid,int assetid, String token)async{
return assetBarcodeRepository.getAssetBarcode(processid, assetid,token);
  }
}