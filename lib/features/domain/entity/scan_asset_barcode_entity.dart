import 'package:equatable/equatable.dart';
import 'package:suja/features/data/model/asset_barcode_model.dart';

class ScanAssetBarcodeEntity extends Equatable{
final ScanAseetBarcode? scanAseetBarcode;
ScanAssetBarcodeEntity( {this.scanAseetBarcode});

  @override
  // TODO: implement props
  List<Object?> get props => [scanAseetBarcode];
  
}

class ScanAseetBarcode extends Equatable{

    ScanAseetBarcode({
        required this.pamId,
        required this.pamAssetId,
        required this.pamPaId,
        required this.pamMpmId,
    });

    final int? pamId;
    final int? pamAssetId;
    final int? pamPaId;
    final int? pamMpmId;
  @override
  // TODO: implement props
  List<Object?> get props => [pamId,pamAssetId,pamPaId,pamMpmId];
  
}