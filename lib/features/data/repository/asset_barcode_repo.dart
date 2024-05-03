
import 'package:suja/features/data/datasource/remote/actual_qty_datasource.dart';
import 'package:suja/features/data/datasource/remote/asset_barcode_datasource.dart';

import 'package:suja/features/data/model/actual_qty_model.dart';
import 'package:suja/features/data/model/asset_barcode_model.dart';

import 'package:suja/features/domain/repository/asset_barcode_repo.dart';

class AssetBarcodeRepositoryImpl extends AssetBarcodeRepository{
  final  AssetBarcodeDatasource assetBarcodeDatasource;
  AssetBarcodeRepositoryImpl(this.assetBarcodeDatasource); 

  @override
  Future<ScanAssetBarcodeModel> getAssetBarcode(int processid,int assetId, String token) async{
   ScanAssetBarcodeModel result= await assetBarcodeDatasource.getAssetBarcode(processid,assetId, token);
    return result;
  }
  
}